#!/bin/bash
# uml.sh — Query UML class diagrams (plain text, Mermaid, PlantUML)
# Source this file: source uml.sh

# =============================================================================
# Auto-detect diagram format
# =============================================================================
_uml_detect_format() {
  local file=$1
  if head -20 "$file" | grep -q 'classDiagram'; then
    echo "mermaid"
  elif head -20 "$file" | grep -q '@startuml'; then
    echo "plantuml"
  else
    echo "plain"
  fi
}

# =============================================================================
# Parse arguments: [-f format] <args...> <file>
# Sets _UML_FORMAT and shifts positional params so file is last ($1, etc.)
# =============================================================================
_uml_parse_args() {
  _UML_FORMAT=""

  while [[ $# -gt 0 ]]; do
    case "$1" in
      -f|--format)
        _UML_FORMAT="$2"
        shift 2
        ;;
      *)
        break
        ;;
    esac
  done

  # If no format specified, auto-detect from the last argument (the file)
  if [[ -z "$_UML_FORMAT" ]]; then
    local file="${@: -1}"
    _UML_FORMAT=$(_uml_detect_format "$file")
  fi
}

# =============================================================================
# uml_classes — List all classes in a UML diagram
# Usage: uml_classes [-f plain|mermaid|plantuml] <file>
# =============================================================================
uml_classes() {
  _uml_parse_args "$@"
  local file="${@: -1}"

  echo "=== Classes in $file (format: $_UML_FORMAT) ==="

  case "$_UML_FORMAT" in
    plain|mermaid)
      awk '/^[[:space:]]*class / { gsub(/\{/, "", $2); print $2 }' "$file"
      ;;
    plantuml)
      # PlantUML: class ClassName { or just class ClassName
      awk '/^[[:space:]]*class / && !/classDiagram/ {
        name = $2
        # Remove any trailing { or whitespace
        gsub(/[[:space:]\{]/, "", name)
        if (name != "" && name !~ /^@/) print name
      }' "$file"
      ;;
  esac
}

# =============================================================================
# uml_class_detail — Show class definition block and its relationships
# Usage: uml_class_detail [-f plain|mermaid|plantuml] <ClassName> <file>
# =============================================================================
uml_class_detail() {
  _uml_parse_args "$@"
  local class_name="${@:(-2):1}"
  local file="${@: -1}"

  echo "=== Class Definition: $class_name (format: $_UML_FORMAT) ==="

  case "$_UML_FORMAT" in
    plain|mermaid)
      awk "/^[[:space:]]*class $class_name[[:space:]]*\{/,/\}/" "$file"
      ;;
    plantuml)
      awk "/^[[:space:]]*class $class_name[[:space:]]*(\{|$)/,/\}/" "$file"
      ;;
  esac

  echo ""
  echo "=== Relationships for $class_name ==="

  case "$_UML_FORMAT" in
    plain)
      awk "/$class_name/ && /<\|--|\*--|o--|--|\*\>|--\>|\.\>/ && !/class / && !/enum /" "$file"
      ;;
    mermaid)
      # Mermaid uses: --|> <|-- *-- o-- --> ..> -- .. etc.
      awk "/$class_name/ && /--|\>\||<\||\.\.|\*\>/ && !/^[[:space:]]*class / && !/^[[:space:]]*enum /" "$file"
      ;;
    plantuml)
      # PlantUML uses: <|-- --|> *-- o-- -- .. etc.
      awk "/$class_name/ && /<\|/ || /\|>/ || /--/ || /\.\./ && !/^[[:space:]]*class / && !/^[[:space:]]*enum / && !/@startuml/ && !/@enduml/" "$file"
      ;;
  esac
}

# =============================================================================
# uml_enum_detail — Show enum definition block
# Usage: uml_enum_detail [-f plain|mermaid|plantuml] <EnumName> <file>
# =============================================================================
uml_enum_detail() {
  _uml_parse_args "$@"
  local enum_name="${@:(-2):1}"
  local file="${@: -1}"

  echo "=== Enum Definition: $enum_name (format: $_UML_FORMAT) ==="

  case "$_UML_FORMAT" in
    plain|mermaid)
      awk "/^[[:space:]]*enum $enum_name[[:space:]]*\{/,/\}/" "$file"
      ;;
    plantuml)
      # PlantUML: enum EnumName { ... }
      awk "/^[[:space:]]*enum $enum_name[[:space:]]*(\{|$)/,/\}/" "$file"
      ;;
  esac
}
