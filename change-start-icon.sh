#!/bin/bash

# Use the current working directory as the icon directory
ICON_DIR="$(pwd)"

# Define the destination directory for the GNOME Show Applications icon
ICON_DEST_DIR="/usr/share/icons/Yaru/scalable/actions"

# Define the original and backup file names
ORIGINAL_ICON="$ICON_DEST_DIR/view-app-grid-symbolic.svg"
BACKUP_ICON="$ICON_DEST_DIR/view-app-grid-symbolic-old.svg"

# Check if the icon directory exists and contains SVG files
if [ ! -d "$ICON_DIR" ]; then
    echo "Directory $ICON_DIR does not exist. Please run the script from the directory containing the SVG icons."
    exit 1
fi

# Check if there are any SVG files in the directory
if ! ls "$ICON_DIR"/*.svg &> /dev/null; then
    echo "No SVG files found in $ICON_DIR. Please add SVG files to the directory."
    exit 1
fi

# List available SVG files in the directory
echo "Available icons:"
ICONS=($(ls "$ICON_DIR"/*.svg))
select ICON in "${ICONS[@]}"; do
    if [[ -n "$ICON" ]]; then
        echo "You chose $ICON"
        break
    else
        echo "Invalid choice, please select again."
    fi
done

# Backup the original icon if not already backed up
if [ ! -f "$BACKUP_ICON" ]; then
    echo "Backing up the original icon..."
    sudo mv "$ORIGINAL_ICON" "$BACKUP_ICON"
fi

# Copy the selected icon to the destination directory
echo "Copying the selected icon to $ICON_DEST_DIR..."
sudo cp "$ICON" "$ICON_DEST_DIR"

# Rename the copied file to view-app-grid-symbolic.svg
NEW_ICON_NAME="$ICON_DEST_DIR/view-app-grid-symbolic.svg"
echo "Renaming the copied icon to $NEW_ICON_NAME..."
sudo mv "$ICON_DEST_DIR/$(basename "$ICON")" "$NEW_ICON_NAME"

# Update the icon cache
echo "Updating icon cache..."
sudo gtk-update-icon-cache /usr/share/icons/Yaru/

# Restart GNOME Shell
echo "Restarting GNOME Shell..."
gnome-shell --replace & disown

echo "Icon changed successfully!"
#sudo pkill -u username
