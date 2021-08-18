# sync rom
repo init --depth=1 --no-repo-verify -u https://github.com/DotOS/manifest.git -b dot11 -g default,-device,-mips,-darwin,-notdefault
git clone https://gitlab.com/hdrjt/local_manifest.git -b dot-11 --depth=1 .repo/local_manifests
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j8

# build rom
source build/envsetup.sh
lunch dot_onclite-userdebug
export TZ=Asia/Jakarta #put before last build command
make bacon -j$(nproc --all)

# upload rom (if you don't need to upload multiple files, then you don't need to edit next line)
rclone copy out/target/product/$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1)/*.zip cirrus:$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1) -P
