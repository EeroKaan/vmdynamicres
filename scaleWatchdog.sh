#/bin/bash

X=$(xrandr --current | grep '*' | uniq | awk '{print $1}' | cut -d 'x' -f1)
Y=$(xrandr --current | grep '*' | uniq | awk '{print $1}' | cut -d 'x' -f2)

FACTOR=$(cat /usr/share/glib-2.0/schemas/90_hidpi.gschema.override | grep -Po '(?<=^scaling-factor=)\w*$')

# Display is larger than Full HD
if [ "$X" -gt "1920" ] && [ "$Y" -gt "1080" ]; then

    # Switch GNOME Scaling Factor
    if [ "$FACTOR" -eq "1" ]; then
        sed -i 's/scaling-factor=1/scaling-factor=2/g' /usr/share/glib-2.0/schemas/90_hidpi.gschema.override
        glib-compile-schemas /usr/share/glib-2.0/schemas
        shutdown -r now
    fi

    # Trigger initiallialy
    bash /usr/local/bin/vmdynamicres/scaleSet125.sh

    # Trigger after Resolution Change
    /usr/local/bin/vmdynamicres/xeventbind resolution /usr/local/bin/vmdynamicres/scaleSet125.sh

# Display is smaller than Full HD
else

    # Switch GNOME Scaling Factor
    if [ "$FACTOR" -eq "2" ]; then
        sed -i 's/scaling-factor=2/scaling-factor=1/g' /usr/share/glib-2.0/schemas/90_hidpi.gschema.override
        glib-compile-schemas /usr/share/glib-2.0/schemas
        shutdown -r now
    fi

# Finish
fi
