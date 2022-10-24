#! /bin/sh

test -n "${DISPLAY}${WAYLAND_DISPLAY}" && exit 1

# vconsoleだとフォントが無いので、wayland上でのみ日本語ロケールを使う
export LANG="ja_JP.UTF-8"

# fcitx5用の設定
export GTK_IM_MODULE="fcitx"
export QT_IM_MODULE="fcitx"
export XMODIFIERS="@im=fcitx"
export SDL_IM_MODULE="fcitx"

# Qtアプリケーションをwaylandで動かすための設定
export QT_QPA_PLATFORM="wayland"
export QT_QPA_PLATFORMTHEME="qt5ct"

# alacrittyでは、バックエンドがwaylandだとIMEの変換候補が出ないため、代わりにxwaylandを使う
export WINIT_UNIX_BACKEND="x11"

# firefoxをwaylandで動かすための設定
export MOZ_ENABLE_WAYLAND="1"

exec sway
