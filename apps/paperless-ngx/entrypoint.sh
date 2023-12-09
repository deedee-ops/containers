#!/usr/bin/env bash

# https://github.com/jonaswinkler/paperless-ng/issues/1387#issuecomment-942727072

echo -e '#!/usr/bin/env bash\n' > /tmp/fix-pdf-encryption

if [ -n "${PAPERLESS_PRE_CONSUME_SCRIPT}" ]; then
  echo "${PAPERLESS_PRE_CONSUME_SCRIPT} \$@" >> /tmp/fix-pdf-encryption
  echo -e '\n\n' >> /tmp/fix-pdf-encryption
fi

# shellcheck disable=SC2016
echo -e 'file "${DOCUMENT_WORKING_PATH}" | grep -q "PDF document" && (qpdf --show-encryption "${DOCUMENT_WORKING_PATH}" | grep "File is not encrypted" || qpdf --decrypt --replace-input "${DOCUMENT_WORKING_PATH}")\nexit 0' >> /tmp/fix-pdf-encryption

chmod +x /tmp/fix-pdf-encryption

export PAPERLESS_PRE_CONSUME_SCRIPT=/tmp/fix-pdf-encryption

exec "$@"
