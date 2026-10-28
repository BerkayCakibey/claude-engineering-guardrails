import os
import sys
import logging
from pathlib import Path


logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
)
logger = logging.getLogger(__name__)


def read_file(path: str) -> str:
    try:
        with open(path, "r", encoding="utf-8") as f:
            return f.read()
    except FileNotFoundError:
        logger.error("File not found: %s", path)
        raise
    except PermissionError:
        logger.error("Permission denied: %s", path)
        raise


def validate_env(var: str) -> str:
    value = os.getenv(var)
    if not value:
        logger.error("Environment variable %s is not set", var)
        sys.exit(1)
    return value


def process_file(file_path: str) -> dict:
    content = read_file(file_path)
    lines = content.splitlines()
    return {
        "path": file_path,
        "line_count": len(lines),
        "char_count": len(content),
        "empty_lines": sum(1 for line in lines if not line.strip()),
    }


def main() -> None:
    input_file = validate_env("INPUT_FILE")
    output_dir = validate_env("OUTPUT_DIR")

    file_path = Path(input_file)
    if not file_path.exists():
        logger.error("Input file does not exist: %s", file_path)
        sys.exit(1)

    stats = process_file(str(file_path))
    logger.info(
        "Processed %s: %d lines, %d chars, %d empty",
        stats["path"],
        stats["line_count"],
        stats["char_count"],
        stats["empty_lines"],
    )

    output_path = Path(output_dir)
    output_path.mkdir(parents=True, exist_ok=True)

    result_file = output_path / f"{file_path.stem}_stats.txt"
    result_file.write_text(
        f"File: {stats['path']}\n"
        f"Lines: {stats['line_count']}\n"
        f"Characters: {stats['char_count']}\n"
        f"Empty lines: {stats['empty_lines']}\n",
        encoding="utf-8",
    )
    logger.info("Results written to %s", result_file)


if __name__ == "__main__":
    main()
