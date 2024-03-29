#!/bin/sh
set -e

echo "mkdir -p ${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
mkdir -p "${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"

SWIFT_STDLIB_PATH="${DT_TOOLCHAIN_DIR}/usr/lib/swift/${PLATFORM_NAME}"

install_framework()
{
  if [ -r "${BUILT_PRODUCTS_DIR}/$1" ]; then
    local source="${BUILT_PRODUCTS_DIR}/$1"
  elif [ -r "${BUILT_PRODUCTS_DIR}/$(basename "$1")" ]; then
    local source="${BUILT_PRODUCTS_DIR}/$(basename "$1")"
  elif [ -r "$1" ]; then
    local source="$1"
  fi

  local destination="${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"

  if [ -L "${source}" ]; then
      echo "Symlinked..."
      source="$(readlink "${source}")"
  fi

  # use filter instead of exclude so missing patterns dont' throw errors
  echo "rsync -av --filter \"- CVS/\" --filter \"- .svn/\" --filter \"- .git/\" --filter \"- .hg/\" --filter \"- Headers\" --filter \"- PrivateHeaders\" --filter \"- Modules\" \"${source}\" \"${destination}\""
  rsync -av --filter "- CVS/" --filter "- .svn/" --filter "- .git/" --filter "- .hg/" --filter "- Headers" --filter "- PrivateHeaders" --filter "- Modules" "${source}" "${destination}"

  local basename
  basename="$(basename -s .framework "$1")"
  binary="${destination}/${basename}.framework/${basename}"
  if ! [ -r "$binary" ]; then
    binary="${destination}/${basename}"
  fi

  # Strip invalid architectures so "fat" simulator / device frameworks work on device
  if [[ "$(file "$binary")" == *"dynamically linked shared library"* ]]; then
    strip_invalid_archs "$binary"
  fi

  # Resign the code if required by the build settings to avoid unstable apps
  code_sign_if_enabled "${destination}/$(basename "$1")"

  # Embed linked Swift runtime libraries. No longer necessary as of Xcode 7.
  if [ "${XCODE_VERSION_MAJOR}" -lt 7 ]; then
    local swift_runtime_libs
    swift_runtime_libs=$(xcrun otool -LX "$binary" | grep --color=never @rpath/libswift | sed -E s/@rpath\\/\(.+dylib\).*/\\1/g | uniq -u  && exit ${PIPESTATUS[0]})
    for lib in $swift_runtime_libs; do
      echo "rsync -auv \"${SWIFT_STDLIB_PATH}/${lib}\" \"${destination}\""
      rsync -auv "${SWIFT_STDLIB_PATH}/${lib}" "${destination}"
      code_sign_if_enabled "${destination}/${lib}"
    done
  fi
}

# Signs a framework with the provided identity
code_sign_if_enabled() {
  if [ -n "${EXPANDED_CODE_SIGN_IDENTITY}" -a "${CODE_SIGNING_REQUIRED}" != "NO" -a "${CODE_SIGNING_ALLOWED}" != "NO" ]; then
    # Use the current code_sign_identitiy
    echo "Code Signing $1 with Identity ${EXPANDED_CODE_SIGN_IDENTITY_NAME}"
    echo "/usr/bin/codesign --force --sign ${EXPANDED_CODE_SIGN_IDENTITY} ${OTHER_CODE_SIGN_FLAGS} --preserve-metadata=identifier,entitlements \"$1\""
    /usr/bin/codesign --force --sign ${EXPANDED_CODE_SIGN_IDENTITY} ${OTHER_CODE_SIGN_FLAGS} --preserve-metadata=identifier,entitlements "$1"
  fi
}

# Strip invalid architectures
strip_invalid_archs() {
  binary="$1"
  # Get architectures for current file
  archs="$(lipo -info "$binary" | rev | cut -d ':' -f1 | rev)"
  stripped=""
  for arch in $archs; do
    if ! [[ "${VALID_ARCHS}" == *"$arch"* ]]; then
      # Strip non-valid architectures in-place
      lipo -remove "$arch" -output "$binary" "$binary" || exit 1
      stripped="$stripped $arch"
    fi
  done
  if [[ "$stripped" ]]; then
    echo "Stripped $binary of architectures:$stripped"
  fi
}


if [[ "$CONFIGURATION" == "Debug" ]]; then
  install_framework "$BUILT_PRODUCTS_DIR/AFNetworking/AFNetworking.framework"
  install_framework "$BUILT_PRODUCTS_DIR/Bolts/Bolts.framework"
  install_framework "$BUILT_PRODUCTS_DIR/FBSDKCoreKit/FBSDKCoreKit.framework"
  install_framework "$BUILT_PRODUCTS_DIR/FBSDKLoginKit/FBSDKLoginKit.framework"
  install_framework "$BUILT_PRODUCTS_DIR/FBSDKShareKit/FBSDKShareKit.framework"
  install_framework "$BUILT_PRODUCTS_DIR/Flurry-iOS-SDK/Flurry_iOS_SDK.framework"
  install_framework "$BUILT_PRODUCTS_DIR/GoogleToolboxForMac/GoogleToolboxForMac.framework"
  install_framework "$BUILT_PRODUCTS_DIR/LOCCameraView/LOCCameraView.framework"
  install_framework "$BUILT_PRODUCTS_DIR/LOCFloatingTextField/LOCFloatingTextField.framework"
  install_framework "$BUILT_PRODUCTS_DIR/LOCGenericLogin/LOCGenericLogin.framework"
  install_framework "$BUILT_PRODUCTS_DIR/LOCManagers/LOCManagers.framework"
  install_framework "$BUILT_PRODUCTS_DIR/LOCPasswordTextField/LOCPasswordTextField.framework"
  install_framework "$BUILT_PRODUCTS_DIR/LOCPermissions-Swift/LOCPermissions_Swift.framework"
  install_framework "$BUILT_PRODUCTS_DIR/LOCScrollingTabViewController/LOCScrollingTabViewController.framework"
  install_framework "$BUILT_PRODUCTS_DIR/LOCSearchBar/LOCSearchBar.framework"
  install_framework "$BUILT_PRODUCTS_DIR/LOCSubscription/LOCSubscription.framework"
  install_framework "$BUILT_PRODUCTS_DIR/MTLManagedObjectAdapter/MTLManagedObjectAdapter.framework"
  install_framework "$BUILT_PRODUCTS_DIR/MTLModel-LOCExtensions/MTLModel_LOCExtensions.framework"
  install_framework "$BUILT_PRODUCTS_DIR/Mantle/Mantle.framework"
  install_framework "$BUILT_PRODUCTS_DIR/NSArray-LOCExtensions/NSArray_LOCExtensions.framework"
  install_framework "$BUILT_PRODUCTS_DIR/NSDate-LOCExtensions/NSDate_LOCExtensions.framework"
  install_framework "$BUILT_PRODUCTS_DIR/NSFileManager-LOCExtensions/NSFileManager_LOCExtensions.framework"
  install_framework "$BUILT_PRODUCTS_DIR/NSObject-LOCExtensions/NSObject_LOCExtensions.framework"
  install_framework "$BUILT_PRODUCTS_DIR/NSString-LOCExtensions/NSString_LOCExtensions.framework"
  install_framework "$BUILT_PRODUCTS_DIR/Reachability/Reachability.framework"
  install_framework "$BUILT_PRODUCTS_DIR/SFHFKeychainUtils/SFHFKeychainUtils.framework"
  install_framework "$BUILT_PRODUCTS_DIR/UIAlertController-LOCExtensions/UIAlertController_LOCExtensions.framework"
  install_framework "$BUILT_PRODUCTS_DIR/UIButton-LOCExtensions/UIButton_LOCExtensions.framework"
  install_framework "$BUILT_PRODUCTS_DIR/UIColor-LOCExtensions/UIColor_LOCExtensions.framework"
  install_framework "$BUILT_PRODUCTS_DIR/UIImage-LOCExtensions/UIImage_LOCExtensions.framework"
  install_framework "$BUILT_PRODUCTS_DIR/UIImagePickerController-LOCExtensions/UIImagePickerController_LOCExtensions.framework"
  install_framework "$BUILT_PRODUCTS_DIR/UIImageView-LOCExtensions/UIImageView_LOCExtensions.framework"
  install_framework "$BUILT_PRODUCTS_DIR/UIView-LOCExtensions/UIView_LOCExtensions.framework"
fi
if [[ "$CONFIGURATION" == "Release" ]]; then
  install_framework "$BUILT_PRODUCTS_DIR/AFNetworking/AFNetworking.framework"
  install_framework "$BUILT_PRODUCTS_DIR/Bolts/Bolts.framework"
  install_framework "$BUILT_PRODUCTS_DIR/FBSDKCoreKit/FBSDKCoreKit.framework"
  install_framework "$BUILT_PRODUCTS_DIR/FBSDKLoginKit/FBSDKLoginKit.framework"
  install_framework "$BUILT_PRODUCTS_DIR/FBSDKShareKit/FBSDKShareKit.framework"
  install_framework "$BUILT_PRODUCTS_DIR/Flurry-iOS-SDK/Flurry_iOS_SDK.framework"
  install_framework "$BUILT_PRODUCTS_DIR/GoogleToolboxForMac/GoogleToolboxForMac.framework"
  install_framework "$BUILT_PRODUCTS_DIR/LOCCameraView/LOCCameraView.framework"
  install_framework "$BUILT_PRODUCTS_DIR/LOCFloatingTextField/LOCFloatingTextField.framework"
  install_framework "$BUILT_PRODUCTS_DIR/LOCGenericLogin/LOCGenericLogin.framework"
  install_framework "$BUILT_PRODUCTS_DIR/LOCManagers/LOCManagers.framework"
  install_framework "$BUILT_PRODUCTS_DIR/LOCPasswordTextField/LOCPasswordTextField.framework"
  install_framework "$BUILT_PRODUCTS_DIR/LOCPermissions-Swift/LOCPermissions_Swift.framework"
  install_framework "$BUILT_PRODUCTS_DIR/LOCScrollingTabViewController/LOCScrollingTabViewController.framework"
  install_framework "$BUILT_PRODUCTS_DIR/LOCSearchBar/LOCSearchBar.framework"
  install_framework "$BUILT_PRODUCTS_DIR/LOCSubscription/LOCSubscription.framework"
  install_framework "$BUILT_PRODUCTS_DIR/MTLManagedObjectAdapter/MTLManagedObjectAdapter.framework"
  install_framework "$BUILT_PRODUCTS_DIR/MTLModel-LOCExtensions/MTLModel_LOCExtensions.framework"
  install_framework "$BUILT_PRODUCTS_DIR/Mantle/Mantle.framework"
  install_framework "$BUILT_PRODUCTS_DIR/NSArray-LOCExtensions/NSArray_LOCExtensions.framework"
  install_framework "$BUILT_PRODUCTS_DIR/NSDate-LOCExtensions/NSDate_LOCExtensions.framework"
  install_framework "$BUILT_PRODUCTS_DIR/NSFileManager-LOCExtensions/NSFileManager_LOCExtensions.framework"
  install_framework "$BUILT_PRODUCTS_DIR/NSObject-LOCExtensions/NSObject_LOCExtensions.framework"
  install_framework "$BUILT_PRODUCTS_DIR/NSString-LOCExtensions/NSString_LOCExtensions.framework"
  install_framework "$BUILT_PRODUCTS_DIR/Reachability/Reachability.framework"
  install_framework "$BUILT_PRODUCTS_DIR/SFHFKeychainUtils/SFHFKeychainUtils.framework"
  install_framework "$BUILT_PRODUCTS_DIR/UIAlertController-LOCExtensions/UIAlertController_LOCExtensions.framework"
  install_framework "$BUILT_PRODUCTS_DIR/UIButton-LOCExtensions/UIButton_LOCExtensions.framework"
  install_framework "$BUILT_PRODUCTS_DIR/UIColor-LOCExtensions/UIColor_LOCExtensions.framework"
  install_framework "$BUILT_PRODUCTS_DIR/UIImage-LOCExtensions/UIImage_LOCExtensions.framework"
  install_framework "$BUILT_PRODUCTS_DIR/UIImagePickerController-LOCExtensions/UIImagePickerController_LOCExtensions.framework"
  install_framework "$BUILT_PRODUCTS_DIR/UIImageView-LOCExtensions/UIImageView_LOCExtensions.framework"
  install_framework "$BUILT_PRODUCTS_DIR/UIView-LOCExtensions/UIView_LOCExtensions.framework"
fi
if [[ "$CONFIGURATION" == "AdHoc" ]]; then
  install_framework "$BUILT_PRODUCTS_DIR/AFNetworking/AFNetworking.framework"
  install_framework "$BUILT_PRODUCTS_DIR/Bolts/Bolts.framework"
  install_framework "$BUILT_PRODUCTS_DIR/FBSDKCoreKit/FBSDKCoreKit.framework"
  install_framework "$BUILT_PRODUCTS_DIR/FBSDKLoginKit/FBSDKLoginKit.framework"
  install_framework "$BUILT_PRODUCTS_DIR/FBSDKShareKit/FBSDKShareKit.framework"
  install_framework "$BUILT_PRODUCTS_DIR/Flurry-iOS-SDK/Flurry_iOS_SDK.framework"
  install_framework "$BUILT_PRODUCTS_DIR/GoogleToolboxForMac/GoogleToolboxForMac.framework"
  install_framework "$BUILT_PRODUCTS_DIR/LOCCameraView/LOCCameraView.framework"
  install_framework "$BUILT_PRODUCTS_DIR/LOCFloatingTextField/LOCFloatingTextField.framework"
  install_framework "$BUILT_PRODUCTS_DIR/LOCGenericLogin/LOCGenericLogin.framework"
  install_framework "$BUILT_PRODUCTS_DIR/LOCManagers/LOCManagers.framework"
  install_framework "$BUILT_PRODUCTS_DIR/LOCPasswordTextField/LOCPasswordTextField.framework"
  install_framework "$BUILT_PRODUCTS_DIR/LOCPermissions-Swift/LOCPermissions_Swift.framework"
  install_framework "$BUILT_PRODUCTS_DIR/LOCScrollingTabViewController/LOCScrollingTabViewController.framework"
  install_framework "$BUILT_PRODUCTS_DIR/LOCSearchBar/LOCSearchBar.framework"
  install_framework "$BUILT_PRODUCTS_DIR/LOCSubscription/LOCSubscription.framework"
  install_framework "$BUILT_PRODUCTS_DIR/MTLManagedObjectAdapter/MTLManagedObjectAdapter.framework"
  install_framework "$BUILT_PRODUCTS_DIR/MTLModel-LOCExtensions/MTLModel_LOCExtensions.framework"
  install_framework "$BUILT_PRODUCTS_DIR/Mantle/Mantle.framework"
  install_framework "$BUILT_PRODUCTS_DIR/NSArray-LOCExtensions/NSArray_LOCExtensions.framework"
  install_framework "$BUILT_PRODUCTS_DIR/NSDate-LOCExtensions/NSDate_LOCExtensions.framework"
  install_framework "$BUILT_PRODUCTS_DIR/NSFileManager-LOCExtensions/NSFileManager_LOCExtensions.framework"
  install_framework "$BUILT_PRODUCTS_DIR/NSObject-LOCExtensions/NSObject_LOCExtensions.framework"
  install_framework "$BUILT_PRODUCTS_DIR/NSString-LOCExtensions/NSString_LOCExtensions.framework"
  install_framework "$BUILT_PRODUCTS_DIR/Reachability/Reachability.framework"
  install_framework "$BUILT_PRODUCTS_DIR/SFHFKeychainUtils/SFHFKeychainUtils.framework"
  install_framework "$BUILT_PRODUCTS_DIR/UIAlertController-LOCExtensions/UIAlertController_LOCExtensions.framework"
  install_framework "$BUILT_PRODUCTS_DIR/UIButton-LOCExtensions/UIButton_LOCExtensions.framework"
  install_framework "$BUILT_PRODUCTS_DIR/UIColor-LOCExtensions/UIColor_LOCExtensions.framework"
  install_framework "$BUILT_PRODUCTS_DIR/UIImage-LOCExtensions/UIImage_LOCExtensions.framework"
  install_framework "$BUILT_PRODUCTS_DIR/UIImagePickerController-LOCExtensions/UIImagePickerController_LOCExtensions.framework"
  install_framework "$BUILT_PRODUCTS_DIR/UIImageView-LOCExtensions/UIImageView_LOCExtensions.framework"
  install_framework "$BUILT_PRODUCTS_DIR/UIView-LOCExtensions/UIView_LOCExtensions.framework"
fi
