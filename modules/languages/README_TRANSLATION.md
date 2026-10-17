# DMP Translation Guide

Thank you for helping translate Debian Maintenance Professional.

## How to translate

1. Copy template.lang

Example:

cp template.lang de.lang

2. Translate only the text between quotes.

Example:

MENU_EXIT="Exit"

becomes:

MENU_EXIT="Beenden"

3. Do not change variable names.

Correct:

MENU_SSD="SSD Diagnostics"

Incorrect:

MENU_SSD_DIAGNOSTIC="SSD Diagnostics"

## Testing

Place the new language file in:

languages/

Then test DMP.

Your contribution helps make DMP available worldwide.
