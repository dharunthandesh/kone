"""Schematic Image and PDF Preprocessing Engine."""

import io
from pathlib import Path
from typing import Optional, Tuple
import cv2
import numpy as np
from PIL import Image
from pypdf import PdfReader


class SchematicPreprocessor:
    """Preprocesses circuit schematic images and PDFs for detection."""

    @classmethod
    def load_schematic(cls, file_path: Path) -> Tuple[np.ndarray, Path]:
        """Loads an image or extracts the first page of a PDF.
        Returns:
            (cv2_image_bgr, preview_image_path)
        """
        suffix = file_path.suffix.lower()

        if suffix == ".pdf":
            # Extract image from PDF or render first page
            img_bgr = cls._extract_from_pdf(file_path)
            preview_path = file_path.with_suffix(".png")
            cv2.imwrite(str(preview_path), img_bgr)
            return img_bgr, preview_path
        else:
            # Standard image load
            img_bgr = cv2.imread(str(file_path))
            if img_bgr is None:
                # Fallback to PIL in case of Unicode path or specific format
                pil_img = Image.open(str(file_path)).convert("RGB")
                img_bgr = cv2.cvtColor(np.array(pil_img), cv2.COLOR_RGB2BGR)

            preview_path = file_path
            return img_bgr, preview_path

    @classmethod
    def _extract_from_pdf(cls, pdf_path: Path, page_index: int = 1) -> np.ndarray:
        """Renders vector PDF page into high-res OpenCV image using pymupdf."""
        try:
            import pymupdf
            doc = pymupdf.open(str(pdf_path))
            if not doc:
                raise ValueError("Empty PDF file")
            # Select page 1 (circuit schematic) or page 0 if only 1 page
            target_page_idx = min(page_index if len(doc) > 1 else 0, len(doc) - 1)
            page = doc[target_page_idx]
            pix = page.get_pixmap(dpi=150)
            img_np = np.frombuffer(pix.samples, dtype=np.uint8).reshape((pix.height, pix.width, pix.n))
            if pix.n == 4:
                return cv2.cvtColor(img_np, cv2.COLOR_RGBA2BGR)
            elif pix.n == 3:
                return cv2.cvtColor(img_np, cv2.COLOR_RGB2BGR)
            else:
                return cv2.cvtColor(img_np, cv2.COLOR_GRAY2BGR)
        except Exception as e:
            # Fallback to pypdf
            reader = PdfReader(str(pdf_path))
            first_page = reader.pages[0]
            for img_obj in first_page.images:
                pil_img = Image.open(io.BytesIO(img_obj.data)).convert("RGB")
                return cv2.cvtColor(np.array(pil_img), cv2.COLOR_RGB2BGR)
            canvas = np.ones((1000, 1400, 3), dtype=np.uint8) * 255
            cv2.putText(canvas, f"Vector PDF: {pdf_path.name}", (50, 400),
                        cv2.FONT_HERSHEY_SIMPLEX, 1.0, (50, 50, 50), 2)
            return canvas

    @classmethod
    def preprocess_for_detection(cls, img_bgr: np.ndarray) -> Tuple[np.ndarray, np.ndarray]:
        """Converts to grayscale, enhances contrast, and creates binary stroke mask.
        Returns:
            (gray_image, binary_inverted_mask)
        """
        gray = cv2.cvtColor(img_bgr, cv2.COLOR_BGR2GRAY)

        # Contrast Limited Adaptive Histogram Equalization
        clahe = cv2.createCLAHE(clipLimit=2.0, tileGridSize=(8, 8))
        enhanced = clahe.apply(gray)

        # Invert binary thresholding: strokes become white (255), background becomes black (0)
        # Using Otsu + Adaptive thresholding combination
        blur = cv2.GaussianBlur(enhanced, (3, 3), 0)
        _, binary = cv2.threshold(blur, 0, 255, cv2.THRESH_BINARY_INV + cv2.THRESH_OTSU)

        # Remove speckle noise
        kernel = cv2.getStructuringElement(cv2.MORPH_RECT, (2, 2))
        cleaned = cv2.morphologyEx(binary, cv2.MORPH_OPEN, kernel)

        return gray, cleaned
