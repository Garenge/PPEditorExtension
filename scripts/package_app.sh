#!/usr/bin/env bash

set -euo pipefail

# Build and export the .app into the project's Products directory.
#
# Usage:
#   ./scripts/package_app.sh
#
# Env overrides:
#   SCHEME         - Xcode scheme name (default: PPXcodeEditor)
#   CONFIGURATION  - Build configuration (default: Debug)
#   SDK            - SDK to build against (default: macosx)
#   PROJECT_FILE   - Path to .xcodeproj (default: <repo>/PPXcodeEditor.xcodeproj)
#   PRODUCTS_DIR   - Output directory (default: <repo>/Products)
#   DERIVED_DATA   - DerivedData path (default: <repo>/Products/DerivedData)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

SCHEME="${SCHEME:-PPXcodeEditor}"
CONFIGURATION="${CONFIGURATION:-Debug}"
SDK="${SDK:-macosx}"
PROJECT_FILE="${PROJECT_FILE:-${REPO_ROOT}/PPXcodeEditor.xcodeproj}"
PRODUCTS_DIR="${PRODUCTS_DIR:-${REPO_ROOT}/Products}"
DERIVED_DATA="${DERIVED_DATA:-${PRODUCTS_DIR}/DerivedData}"

if [[ ! -d "${PROJECT_FILE}" ]]; then
  echo "[错误] 未找到 Xcode 工程: ${PROJECT_FILE}" >&2
  exit 1
fi

mkdir -p "${PRODUCTS_DIR}"

echo "[信息] 开始构建: scheme=${SCHEME}, config=${CONFIGURATION}, sdk=${SDK}"
if command -v xcpretty >/dev/null 2>&1; then
  xcodebuild \
    -project "${PROJECT_FILE}" \
    -scheme "${SCHEME}" \
    -configuration "${CONFIGURATION}" \
    -sdk "${SDK}" \
    -derivedDataPath "${DERIVED_DATA}" \
    clean build | xcpretty
else
  echo "[提示] 未检测到 xcpretty，使用原始构建输出。安装可执行: gem install xcpretty"
  xcodebuild \
    -project "${PROJECT_FILE}" \
    -scheme "${SCHEME}" \
    -configuration "${CONFIGURATION}" \
    -sdk "${SDK}" \
    -derivedDataPath "${DERIVED_DATA}" \
    clean build
fi

echo "[信息] 解析构建设置..."
BUILD_SETTINGS=$(xcodebuild \
  -project "${PROJECT_FILE}" \
  -scheme "${SCHEME}" \
  -configuration "${CONFIGURATION}" \
  -sdk "${SDK}" \
  -derivedDataPath "${DERIVED_DATA}" \
  -showBuildSettings 2>/dev/null | sed -n 's/^[ \t]*//p')

TARGET_BUILD_DIR=$(awk -F " = " '/^TARGET_BUILD_DIR/{print $2; exit}' <<<"${BUILD_SETTINGS}")
FULL_PRODUCT_NAME=$(awk -F " = " '/^FULL_PRODUCT_NAME/{print $2; exit}' <<<"${BUILD_SETTINGS}")

if [[ -z "${TARGET_BUILD_DIR:-}" || -z "${FULL_PRODUCT_NAME:-}" ]]; then
  echo "[错误] 无法从构建设置中解析 TARGET_BUILD_DIR 或 FULL_PRODUCT_NAME" >&2
  exit 1
fi

SRC_APP_PATH="${TARGET_BUILD_DIR}/${FULL_PRODUCT_NAME}"
DEST_APP_PATH="${PRODUCTS_DIR}/${FULL_PRODUCT_NAME}"

if [[ ! -d "${SRC_APP_PATH}" ]]; then
  echo "[错误] 未找到已编译的 .app: ${SRC_APP_PATH}" >&2
  echo "[提示] 请确认工程已成功构建，或检查 SCHEME/CONFIGURATION/SDK 设置。" >&2
  exit 1
fi

echo "[信息] 拷贝: ${SRC_APP_PATH} -> ${DEST_APP_PATH}"
rm -rf "${DEST_APP_PATH}"
ditto "${SRC_APP_PATH}" "${DEST_APP_PATH}"

echo "[完成] .app 已输出到: ${DEST_APP_PATH}"


