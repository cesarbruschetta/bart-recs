""" module to methods to main  """
import sys
import logging


from bart_extract.main import run

logger = logging.getLogger(__name__)


if __name__ == "__main__":
    try:
        sys.exit(run(sys.argv[1:]))
    except KeyboardInterrupt:
        # É convencionado no shell que o programa finalizado pelo signal de
        # código N deve retornar o código N + 128.
        sys.exit(130)
    except Exception as exc:
        logger.exception(
            "erro durante a execução da função " "'tools_parser' com os args %s",
            sys.argv[1:],
        )
        sys.exit("Um erro inexperado ocorreu: %s" % exc)
