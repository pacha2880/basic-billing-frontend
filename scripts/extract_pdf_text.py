from pathlib import Path
import PyPDF2


def extract(pdf_path: str, out_path: str) -> None:
    p = Path(pdf_path)
    reader = PyPDF2.PdfReader(str(p))
    pages_text = []
    for page in reader.pages:
        t = page.extract_text()
        if t:
            pages_text.append(t)
    Path(out_path).write_text("\n\n".join(pages_text), encoding="utf-8")


if __name__ == "__main__":
    extract("docs/requirements-frontend.pdf", "docs/requirements-frontend-raw.txt")
    extract("docs/requirements-backend.pdf", "docs/requirements-backend-raw.txt")
    print("Extracted PDFs to docs/requirements-*-raw.txt")
