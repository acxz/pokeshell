system_user_dir := '/usr/local/'

install install_dir=system_user_dir:
    ./install.sh {{install_dir}}

uninstall install_dir=system_user_dir:
    ./uninstall.sh {{install_dir}}
