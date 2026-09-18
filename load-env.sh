SILENT=false

while getopts "s" opt; do
    case "$opt" in
        s) SILENT=true ;;
        *) exit 1 ;;
    esac
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
ENV_FILE="$SCRIPT_DIR/.env"

if [ -f "$ENV_FILE" ]; then
    while IFS= read -r line || [ -n "$line" ]; do
        line=$(echo "$line" | tr -d '\r')

        # CHANGED: Standard sh syntax to skip empty lines and comments
        case "$line" in
            "" | \#*) continue ;;
            *) export "$line" ;;
        esac
    done < "$ENV_FILE"
    $SILENT || echo "✅ Successfully exported variables from $ENV_FILE"
else
    echo "❌ Error: File $ENV_FILE not found." >&2
    exit 1
