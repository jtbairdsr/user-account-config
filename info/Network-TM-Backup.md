1. Mount Network Drive

    ```zsh
        mount_smbfs //[user]@[server]/[folder] Volumes/[name of folder]
    ```

2. Make the network device visible to Time Machine - *this will already be done if you ran the setup script*

    ```zsh
        defaults write com.apple.systempreferences TMShowUnsupportedNetworkVolumes 1
    ```

2. Create Sparse Bundle big enough for your backup on the network drive

    ```zsh
        hdiutil create -size [the size of your backup i.e. 400g] -fs HFS+J -volname [name of your backup i.e. "Ex Backup"] [name of the sparse bundle which must be {machine name i.e. haven}_{MAC address}]
    ```

3. Open Time Machine Prefs and it should be there