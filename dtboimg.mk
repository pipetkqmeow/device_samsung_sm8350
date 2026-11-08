#
# Copyright (C) 2026 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#
# Custom dtbo.img rule for o1q.
#
# The Samsung palette overlays are packed in the exact stock order:
#
#   idx 0: o1q_chn_openx_w00_r05
#   idx 1: o1q_chn_openx_w00_r09
#   idx 2: o1q_chn_openx_w00_r12
#   idx 3: o1q_chn_openx_w00_r14  <- used by SM-G9910 rp=16 (ro.boot.dtbo_idx=3)
#   idx 4: o1q_chn_openx_w00_r07
#
# The bootloader (ABL) selects the overlay by parsing qcom,board-id /
# dtbo-hw_rev from the blobs themselves (the stock entry table carries
# zeroed metadata), so the order is mostly a stock-behaviour guarantee.
#

MKDTIMG := $(HOST_OUT_EXECUTABLES)/mkdtimg$(HOST_EXECUTABLE_SUFFIX)
MKDTBOIMG := $(HOST_OUT_EXECUTABLES)/mkdtboimg$(HOST_EXECUTABLE_SUFFIX)

DTBO_PALETTE := samsung/palette/o1q

$(DTBO_OUT):
	mkdir -p $(DTBO_OUT)

$(BOARD_PREBUILT_DTBOIMAGE): $(DTBO_OUT) $(DTC) $(MKDTBOIMG)
	@echo "Building dtbo.img (stock palette order)"
	$(hide) find $(DTBO_OUT)/arch/$(KERNEL_ARCH)/boot/dts -type f -name "*.dtbo" | xargs rm -f
	$(call make-dtbo-target,$(KERNEL_DEFCONFIG))
	$(call make-dtbo-target,dtbs)
	$(MKDTBOIMG) create $@ --page_size=$(BOARD_KERNEL_PAGESIZE) \
		$(DTBO_OUT)/arch/$(KERNEL_ARCH)/boot/dts/$(DTBO_PALETTE)/o1q_chn_openx_w00_r05.dtbo \
		$(DTBO_OUT)/arch/$(KERNEL_ARCH)/boot/dts/$(DTBO_PALETTE)/o1q_chn_openx_w00_r09.dtbo \
		$(DTBO_OUT)/arch/$(KERNEL_ARCH)/boot/dts/$(DTBO_PALETTE)/o1q_chn_openx_w00_r12.dtbo \
		$(DTBO_OUT)/arch/$(KERNEL_ARCH)/boot/dts/$(DTBO_PALETTE)/o1q_chn_openx_w00_r14.dtbo \
		$(DTBO_OUT)/arch/$(KERNEL_ARCH)/boot/dts/$(DTBO_PALETTE)/o1q_chn_openx_w00_r07.dtbo
	$(hide) touch -c $(DTBO_OUT)
