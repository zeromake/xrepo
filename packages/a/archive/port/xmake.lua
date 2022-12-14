includes("check_cincludes.lua")
includes("check_csnippets.lua")
includes("check_cfuncs.lua")
includes("check_ctypes.lua")
add_rules("mode.debug", "mode.release")

local options = {
    -- tls lib
    "mbedtls",
    "nettle",
    "openssl",

    -- decrypt lib
    -- "b2",
    "cng",

    -- compression lib
    "lz4",
    "lzo",
    "lzma",
    "zstd",
    "zlib",
    "bzip2",

    -- xml lib
    "xml2",
    "expat",
    "pcre2",

    -- other lib
    "iconv",
}

for _, op in ipairs(options) do
    option(op)
        set_default(false)
        set_showmenu(true)
    option_end()
    if has_config(op) then 
        add_requires(op)
    end
end

if is_plat("windows") then
    add_cxflags("/utf-8")
end

local sourceFiles = {
    "archive_acl.c",
    "archive_check_magic.c",
    "archive_cmdline.c",
    "archive_cryptor.c",
    "archive_digest.c",
    "archive_entry.c",
    "archive_entry_copy_stat.c",
    "archive_entry_link_resolver.c",
    "archive_entry_sparse.c",
    "archive_entry_stat.c",
    "archive_entry_strmode.c",
    "archive_entry_xattr.c",
    "archive_getdate.c",
    "archive_hmac.c",
    "archive_match.c",
    "archive_options.c",
    "archive_pack_dev.c",
    "archive_pathmatch.c",
    "archive_ppmd8.c",
    "archive_ppmd7.c",
    "archive_random.c",
    "archive_rb.c",
    "archive_read.c",
    "archive_read_add_passphrase.c",
    "archive_read_append_filter.c",
    "archive_read_data_into_fd.c",
    "archive_read_disk_entry_from_file.c",
    "archive_read_disk_posix.c",
    "archive_read_disk_set_standard_lookup.c",
    "archive_read_extract.c",
    "archive_read_extract2.c",
    "archive_read_open_fd.c",
    "archive_read_open_file.c",
    "archive_read_open_filename.c",
    "archive_read_open_memory.c",
    "archive_read_set_format.c",
    "archive_read_set_options.c",
    "archive_read_support_filter_all.c",
    "archive_read_support_filter_by_code.c",
    "archive_read_support_filter_bzip2.c",
    "archive_read_support_filter_compress.c",
    "archive_read_support_filter_gzip.c",
    "archive_read_support_filter_grzip.c",
    "archive_read_support_filter_lrzip.c",
    "archive_read_support_filter_lz4.c",
    "archive_read_support_filter_lzop.c",
    "archive_read_support_filter_none.c",
    "archive_read_support_filter_program.c",
    "archive_read_support_filter_rpm.c",
    "archive_read_support_filter_uu.c",
    "archive_read_support_filter_xz.c",
    "archive_read_support_filter_zstd.c",
    "archive_read_support_format_7zip.c",
    "archive_read_support_format_all.c",
    "archive_read_support_format_ar.c",
    "archive_read_support_format_by_code.c",
    "archive_read_support_format_cab.c",
    "archive_read_support_format_cpio.c",
    "archive_read_support_format_empty.c",
    "archive_read_support_format_iso9660.c",
    "archive_read_support_format_lha.c",
    "archive_read_support_format_mtree.c",
    "archive_read_support_format_rar.c",
    "archive_read_support_format_rar5.c",
    "archive_read_support_format_raw.c",
    "archive_read_support_format_tar.c",
    "archive_read_support_format_warc.c",
    "archive_read_support_format_xar.c",
    "archive_read_support_format_zip.c",
    "archive_string.c",
    "archive_string_sprintf.c",
    "archive_util.c",
    "archive_version_details.c",
    "archive_virtual.c",
    "archive_write.c",
    "archive_write_disk_posix.c",
    "archive_write_disk_set_standard_lookup.c",
    "archive_write_open_fd.c",
    "archive_write_open_file.c",
    "archive_write_open_filename.c",
    "archive_write_open_memory.c",
    "archive_write_add_filter.c",
    "archive_write_add_filter_b64encode.c",
    "archive_write_add_filter_by_name.c",
    "archive_write_add_filter_bzip2.c",
    "archive_write_add_filter_compress.c",
    "archive_write_add_filter_grzip.c",
    "archive_write_add_filter_gzip.c",
    "archive_write_add_filter_lrzip.c",
    "archive_write_add_filter_lz4.c",
    "archive_write_add_filter_lzop.c",
    "archive_write_add_filter_none.c",
    "archive_write_add_filter_program.c",
    "archive_write_add_filter_uuencode.c",
    "archive_write_add_filter_xz.c",
    "archive_write_add_filter_zstd.c",
    "archive_write_set_format.c",
    "archive_write_set_format_7zip.c",
    "archive_write_set_format_ar.c",
    "archive_write_set_format_by_name.c",
    "archive_write_set_format_cpio.c",
    "archive_write_set_format_cpio_binary.c",
    "archive_write_set_format_cpio_newc.c",
    "archive_write_set_format_cpio_odc.c",
    "archive_write_set_format_filter_by_ext.c",
    "archive_write_set_format_gnutar.c",
    "archive_write_set_format_iso9660.c",
    "archive_write_set_format_mtree.c",
    "archive_write_set_format_pax.c",
    "archive_write_set_format_raw.c",
    "archive_write_set_format_shar.c",
    "archive_write_set_format_ustar.c",
    "archive_write_set_format_v7tar.c",
    "archive_write_set_format_warc.c",
    "archive_write_set_format_xar.c",
    "archive_write_set_format_zip.c",
    "archive_write_set_options.c",
    "archive_write_set_passphrase.c",
    "filter_fork_posix.c",
    "xxhash.c",
}

local windowsFiles = {
    "archive_entry_copy_bhfi.c",
    "archive_read_disk_windows.c",
    "archive_windows.c",
    "archive_write_disk_windows.c",
    "filter_fork_windows.c",
}

function configvar_check_csymbol_exists(define_name, var_name, opt) 
    configvar_check_csnippets(define_name, 'void* a = (void*)'..var_name..';', opt)
end

function configvar_check_sizeof(define_name, type_name)
    configvar_check_csnippets(define_name, 'printf("%d", sizeof('..type_name..')); return 0;', {output = true, number = true})
end

target("archive")
    set_kind("$(kind)")
    
    configvar_check_cincludes("HAVE_SYS_TYPES_H", "sys/types.h")
    configvar_check_cincludes("HAVE_ACL_LIBACL_H", "acl/libacl.h")
    configvar_check_cincludes("HAVE_ATTR_XATTR_H", "attr/xattr.h")
    configvar_check_cincludes("HAVE_CTYPE_H", "ctype.h")
    configvar_check_cincludes("HAVE_COPYFILE_H", "copyfile.h")
    configvar_check_cincludes("HAVE_DIRECT_H", "direct.h")
    configvar_check_cincludes("HAVE_DLFCN_H", "dlfcn.h")
    configvar_check_cincludes("HAVE_ERRNO_H", "errno.h")
    configvar_check_cincludes("HAVE_EXT2FS_EXT2_FS_H", "ext2fs/ext2_fs.h")

    configvar_check_cincludes("HAVE_FCNTL_H", "fcntl.h")
    configvar_check_cincludes("HAVE_GRP_H", "grp.h")
    configvar_check_cincludes("HAVE_INTTYPES_H", "inttypes.h")
    configvar_check_cincludes("HAVE_IO_H", "io.h")
    configvar_check_cincludes("HAVE_LANGINFO_H", "langinfo.h")
    configvar_check_cincludes("HAVE_LIMITS_H", "limits.h")
    configvar_check_cincludes("HAVE_LINUX_TYPES_H", "linux/types.h")
    configvar_check_cincludes("HAVE_LINUX_FIEMAP_H", "linux/fiemap.h")
    configvar_check_cincludes("HAVE_LINUX_FS_H", "linux/fs.h")

    configvar_check_cincludes("HAVE_LINUX_MAGIC_H", "linux/magic.h")
    configvar_check_cincludes("HAVE_LOCALE_H", "locale.h")
    configvar_check_cincludes("HAVE_MEMBERSHIP_H", "membership.h")
    configvar_check_cincludes("HAVE_MEMORY_H", "memory.h")
    configvar_check_cincludes("HAVE_PATHS_H", "paths.h")
    configvar_check_cincludes("HAVE_POLL_H", "poll.h")
    configvar_check_cincludes("HAVE_PROCESS_H", "process.h")
    configvar_check_cincludes("HAVE_PTHREAD_H", "pthread.h")
    configvar_check_cincludes("HAVE_PWD_H", "pwd.h")
    configvar_check_cincludes("HAVE_READPASSPHRASE_H", "readpassphrase.h")
    configvar_check_cincludes("HAVE_REGEX_H", "regex.h")
    configvar_check_cincludes("HAVE_SIGNAL_H", "signal.h")
    configvar_check_cincludes("HAVE_SPAWN_H", "spawn.h")
    configvar_check_cincludes("HAVE_STDARG_H", "stdarg.h")
    configvar_check_cincludes("HAVE_STDINT_H", "stdint.h")
    configvar_check_cincludes("HAVE_STDLIB_H", "stdlib.h")
    configvar_check_cincludes("HAVE_STRING_H", "string.h")
    configvar_check_cincludes("HAVE_STRINGS_H", "strings.h")
    configvar_check_cincludes("HAVE_SYS_ACL_H", "sys/acl.h")
    configvar_check_cincludes("HAVE_SYS_CDEFS_H", "sys/cdefs.h")
    configvar_check_cincludes("HAVE_SYS_EXTATTR_H", "sys/extattr.h")
    configvar_check_cincludes("HAVE_SYS_IOCTL_H", "sys/ioctl.h")
    configvar_check_cincludes("HAVE_SYS_MKDEV_H", "sys/mkdev.h")
    configvar_check_cincludes("HAVE_SYS_MOUNT_H", "sys/mount.h")
    configvar_check_cincludes("HAVE_SYS_PARAM_H", "sys/param.h")
    configvar_check_cincludes("HAVE_SYS_POLL_H", "sys/poll.h")
    configvar_check_cincludes("HAVE_SYS_RICHACL_H", "sys/richacl.h")
    configvar_check_cincludes("HAVE_SYS_SELECT_H", "sys/select.h")
    configvar_check_cincludes("HAVE_SYS_STAT_H", "sys/stat.h")
    configvar_check_cincludes("HAVE_SYS_STATFS_H", "sys/statfs.h")
    configvar_check_cincludes("HAVE_SYS_STATVFS_H", "sys/statvfs.h")
    configvar_check_cincludes("HAVE_SYS_SYSMACROS_H", "sys/sysmacros.h")
    configvar_check_cincludes("HAVE_SYS_TIME_H", "sys/time.h")
    configvar_check_cincludes("HAVE_SYS_UTIME_H", "sys/utime.h")
    configvar_check_cincludes("HAVE_SYS_UTSNAME_H", "sys/utsname.h")
    configvar_check_cincludes("HAVE_SYS_VFS_H", "sys/vfs.h")
    configvar_check_cincludes("HAVE_SYS_WAIT_H", "sys/wait.h")
    configvar_check_cincludes("HAVE_SYS_XATTR_H", "sys/xattr.h")
    configvar_check_cincludes("HAVE_TIME_H", "time.h")
    configvar_check_cincludes("HAVE_UNISTD_H", "unistd.h")
    configvar_check_cincludes("HAVE_UTIME_H", "utime.h")
    configvar_check_cincludes("HAVE_WCHAR_H", "wchar.h")
    configvar_check_cincludes("HAVE_WCTYPE_H", "wctype.h")
    configvar_check_cincludes("HAVE_WINDOWS_H", "windows.h")

    local stdintHeaders = {"stdint.h"}

    configvar_check_csymbol_exists("HAVE__CrtSetReportMode", "_CrtSetReportMode", {includes={"crtdbg.h"}})
    configvar_check_csymbol_exists("HAVE_EFTYPE", "EFTYPE", {includes={"errno.h"}})
    configvar_check_csymbol_exists("HAVE_EILSEQ", "EILSEQ", {includes={"errno.h"}})
    configvar_check_csymbol_exists("HAVE_D_MD_ORDER", "D_MD_ORDER", {includes={"langinfo.h"}})
    configvar_check_csymbol_exists("HAVE_DECL_INT32_MAX", "INT32_MAX", {includes=stdintHeaders})
    configvar_check_csymbol_exists("HAVE_DECL_INT32_MIN", "INT32_MIN", {includes=stdintHeaders})
    configvar_check_csymbol_exists("HAVE_DECL_INT64_MAX", "INT64_MAX", {includes=stdintHeaders})
    configvar_check_csymbol_exists("HAVE_DECL_INT64_MIN", "INT64_MIN", {includes=stdintHeaders})
    configvar_check_csymbol_exists("HAVE_DECL_INTMAX_MAX", "INTMAX_MAX", {includes=stdintHeaders})
    configvar_check_csymbol_exists("HAVE_DECL_INTMAX_MIN", "INTMAX_MIN", {includes=stdintHeaders})
    configvar_check_csymbol_exists("HAVE_DECL_UINT32_MAX", "UINT32_MAX", {includes=stdintHeaders})
    configvar_check_csymbol_exists("HAVE_DECL_UINT64_MAX", "UINT64_MAX", {includes=stdintHeaders})
    configvar_check_csymbol_exists("HAVE_DECL_UINTMAX_MAX", "UINTMAX_MAX", {includes=stdintHeaders})
    configvar_check_csymbol_exists("HAVE_DECL_SIZE_MAX", "SIZE_MAX", {includes=stdintHeaders})
    configvar_check_csymbol_exists("HAVE_DECL_SSIZE_MAX", "SSIZE_MAX", {includes={"limits.h"}})




    add_defines("HAVE_CONFIG_H=1")

    for _, op in ipairs(options) do
        if has_config(op) then
            add_packages(op)
            if op == "zlib" then
                set_configvar("HAVE_LIBZ", 1)
                set_configvar("HAVE_ZLIB_H", 1)
            elseif op == "bzip2" then
                set_configvar("HAVE_LIBBZ2", 1)
                set_configvar("HAVE_BZLIB_H", 1)
            elseif op == "bzip2" then
                set_configvar("HAVE_LIBBZ2", 1)
                set_configvar("HAVE_BZLIB_H", 1)
            elseif op == "lzma" then
                set_configvar("HAVE_LIBLZMA", 1)
                set_configvar("HAVE_LZMA_H", 1)
            elseif op == "lzo" then
                set_configvar("HAVE_LIBLZO2", 1)
                set_configvar("HAVE_LZO_LZOCONF_H", 1)
                set_configvar("HAVE_LZO_LZO1X_H", 1)
            elseif op == "lz4" then
                set_configvar("HAVE_LIBLZ4", 1)
                set_configvar("HAVE_LZ4_H", 1)
            elseif op == "zstd" then
                set_configvar("HAVE_ZSTD_H", 1)
            elseif op == "mbedtls" then
                set_configvar("HAVE_LIBMBEDCRYPTO", 1)
                configvar_check_cincludes("HAVE_MBEDTLS_AES_H", "mbedtls/aes.h")
                configvar_check_cincludes("HAVE_MBEDTLS_MD_H", "mbedtls/md.h")
                configvar_check_cincludes("HAVE_MBEDTLS_PKCS5_H", "mbedtls/pkcs5.h")
            elseif op == "nettle" then
                set_configvar("HAVE_LIBNETTLE", 1)
                configvar_check_cincludes("HAVE_NETTLE_AES_H", "nettle/aes.h")
                configvar_check_cincludes("HAVE_NETTLE_HMAC_H", "nettle/hmac.h")
                configvar_check_cincludes("HAVE_NETTLE_MD5_H", "nettle/md5.h")
                configvar_check_cincludes("HAVE_NETTLE_PBKDF2_H", "nettle/pbkdf2.h")
                configvar_check_cincludes("HAVE_NETTLE_RIPEMD160_H", "nettle/ripemd160.h")
                configvar_check_cincludes("HAVE_NETTLE_SHA_H", "nettle/sha.h")
            elseif op == "openssl" then
                set_configvar("HAVE_LIBCRYPTO", 1)
            end
        end
    end

    for _, f in ipairs(sourceFiles) do
        add_files(path.join("libarchive", f))
    end
