# omarchy_desktop

Omarchy configuration repository for my desktop setup.

## Symlink setup

Run `./stow.sh` to create symbolic links from the `Projects` folder into `~/.config`.

This setup expects `~/.config` **not** to be an existing directory.  
If `~/.config` already exists, remove it first so the script can replace it with a symlink pointing to the configuration files stored in the `Projects` folder.

This approach keeps all configuration files in a single location, making them easier to manage and version control.
