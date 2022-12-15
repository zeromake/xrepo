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
    -- "cng",

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

function configvar_check_csymbol_exists(define_name, var_name, opt) 
    configvar_check_csnippets(define_name, 'void* a = (void*)'..var_name..';', opt)
end

function configvar_check_sizeof(define_name, type_name)
    configvar_check_csnippets(define_name, 'printf("%d", sizeof('..type_name..'));return 0;', {output = true, number = true, includes={"stdint.h"}})
    configvar_check_csnippets("HAVE_"..define_name, type_name..' a;', {includes={"stdint.h"}})
end

function configvar_check_has_member(define_name, type_name, member, opt)
    local opts = table.join({}, opt)
    configvar_check_csnippets(define_name, format("%s a;void b = a.%s", type_name, member)..'', opts)
end

target("archive")
    set_kind("$(kind)")

    set_configdir("$(buildir)/config")
    add_includedirs("$(buildir)/config")
    add_configfiles("config.h.in")

    add_includedirs(".")
    
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
    configvar_check_cincludes("HAVE_WINCRYPT_H", "wincrypt.h")
    configvar_check_cincludes("HAVE_WINIOCTL_H", "winioctl.h")
    configvar_check_cincludes("HAVE_DIRENT_H", "dirent.h")

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

    configvar_check_csymbol_exists("HAVE_WORKING_EXT2_IOC_GETFLAGS", "EXT2_IOC_GETFLAGS", {includes={"sys/ioctl.h", "ext2fs/ext2_fs.h"}})
    configvar_check_csymbol_exists("HAVE_WORKING_FS_IOC_GETFLAGS", "FS_IOC_GETFLAGS", {includes={"sys/ioctl.h", "linux/fs.h"}})

    configvar_check_cfuncs("HAVE_ARC4RANDOM_BUF", "arc4random_buf", {includes={"stdlib.h"}})
    configvar_check_cfuncs("HAVE_CHFLAGS", "chflags", {includes={"sys/stat.h"}})
    configvar_check_cfuncs("HAVE_CHOWN", "chown", {includes={"unistd.h"}})
    configvar_check_cfuncs("HAVE_CHROOT", "chroot", {includes={"unistd.h"}})
    configvar_check_cfuncs("HAVE_CTIME_R", "ctime_r", {includes={"time.h"}})
    configvar_check_cfuncs("HAVE_FCHDIR", "fchdir", {includes={"unistd.h"}})
    configvar_check_cfuncs("HAVE_FCHFLAGS", "fchflags", {includes={"sys/stat.h"}})
    configvar_check_cfuncs("HAVE_FCHMOD", "fchmod", {includes={"sys/stat.h"}})
    configvar_check_cfuncs("HAVE_FCHOWN", "fchown", {includes={"sys/stat.h"}})
    configvar_check_cfuncs("HAVE_FCNTL", "fcntl", {includes={"fcntl.h"}})
    configvar_check_cfuncs("HAVE_FDOPENDIR", "fdopendir", {includes={"dirent.h"}})
    configvar_check_cfuncs("HAVE_FORK", "fork", {includes={"unistd.h"}})
    configvar_check_cfuncs("HAVE_FSTAT", "fstat", {includes={"sys/stat.h"}})
    configvar_check_cfuncs("HAVE_FSTATAT", "fstatat", {includes={"sys/stat.h"}})
    configvar_check_cfuncs("HAVE_FSTATFS", "fstatfs", {includes={"sys/statfs.h"}})
    configvar_check_cfuncs("HAVE_FSTATVFS", "fstatvfs", {includes={"sys/statvfs.h"}})
    configvar_check_cfuncs("HAVE_FTRUNCATE", "ftruncate", {includes={"unistd.h"}})
    configvar_check_cfuncs("HAVE_FUTIMENS", "futimens", {includes={"sys/stat.h"}})
    configvar_check_cfuncs("HAVE_FUTIMES", "futimes", {includes={"sys/time.h"}})
    configvar_check_cfuncs("HAVE_FUTIMESAT", "futimesat", {includes={"fcntl.h", "sys/time.h"}})
    configvar_check_cfuncs("HAVE_GETEUID", "geteuid", {includes={"unistd.h"}})
    configvar_check_cfuncs("HAVE_GETGRGID_R", "getgrgid_r", {includes={"grp.h"}})
    configvar_check_cfuncs("HAVE_GETGRNAM_R", "getgrnam_r", {includes={"grp.h"}})
    configvar_check_cfuncs("HAVE_GETPWNAM_R", "getpwnam_r", {includes={"pwd.h"}})
    configvar_check_cfuncs("HAVE_GETPWUID_R", "getpwuid_r", {includes={"pwd.h"}})
    configvar_check_cfuncs("HAVE_GETPID", "getpid", {includes={"unistd.h"}})
    configvar_check_cfuncs("HAVE_GETVFSBYNAME", "getvfsbyname", {includes={"sys/mount.h"}})
    configvar_check_cfuncs("HAVE_GMTIME_R", "gmtime_r", {includes={"time.h"}})
    configvar_check_cfuncs("HAVE_LCHFLAGS", "lchflags", {includes={"sys/stat.h"}})
    configvar_check_cfuncs("HAVE_LCHMOD", "lchmod", {includes={"sys/stat.h"}})
    configvar_check_cfuncs("HAVE_LCHOWN", "lchown", {includes={"sys/stat.h"}})
    configvar_check_cfuncs("HAVE_LINK", "link", {includes={"unistd.h"}})
    configvar_check_cfuncs("HAVE_LINKAT", "linkat", {includes={"unistd.h"}})
    configvar_check_cfuncs("HAVE_LOCALTIME_R", "localtime_r", {includes={"time.h"}})
    configvar_check_cfuncs("HAVE_LSTAT", "lstat", {includes={"sys/stat.h"}})
    configvar_check_cfuncs("HAVE_LUTIMES", "lutimes", {includes={"sys/time.h"}})
    configvar_check_cfuncs("HAVE_MBRTOWC", "mbrtowc", {includes={"wchar.h"}})
    configvar_check_cfuncs("HAVE_MEMMOVE", "memmove", {includes={"string.h"}})
    configvar_check_cfuncs("HAVE_MKDIR", "mkdir", {includes={"sys/stat.h"}})
    configvar_check_cfuncs("HAVE_MKFIFO", "mkfifo", {includes={"sys/stat.h"}})
    configvar_check_cfuncs("HAVE_MKNOD", "mknod", {includes={"sys/stat.h"}})
    configvar_check_cfuncs("HAVE_MKSTEMP", "mkstemp", {includes={"stdlib.h"}})
    configvar_check_cfuncs("HAVE_NL_LANGINFO", "nl_langinfo", {includes={"langinfo.h"}})
    configvar_check_cfuncs("HAVE_OPENAT", "openat", {includes={"fcntl.h"}})
    configvar_check_cfuncs("HAVE_PIPE", "pipe", {includes={"unistd.h"}})
    configvar_check_cfuncs("HAVE_POLL", "poll", {includes={"unistd.h"}})
    configvar_check_cfuncs("HAVE_POSIX_SPAWNP", "posix_spawnp", {includes={"spawn.h"}})
    configvar_check_cfuncs("HAVE_READLINK", "readlink", {includes={"unistd.h"}})
    configvar_check_cfuncs("HAVE_READPASSPHRASE", "readpassphrase", {includes={"readpassphrase.h"}})
    configvar_check_cfuncs("HAVE_SELECT", "select", {includes={"sys/select.h"}})
    configvar_check_cfuncs("HAVE_SETENV", "setenv", {includes={"stdlib.h"}})
    configvar_check_cfuncs("HAVE_SETLOCALE", "setlocale", {includes={"locale.h"}})
    configvar_check_cfuncs("HAVE_SIGACTION", "sigaction", {includes={"signal.h"}})
    configvar_check_cfuncs("HAVE_STATFS", "statfs", {includes={"sys/statfs.h"}})
    configvar_check_cfuncs("HAVE_STATVFS", "statvfs", {includes={"sys/statvfs.h"}})
    configvar_check_cfuncs("HAVE_STRCHR", "strchr", {includes={"string.h"}})
    configvar_check_cfuncs("HAVE_STRDUP", "strdup", {includes={"string.h"}})
    configvar_check_cfuncs("HAVE_STRERROR", "strerror", {includes={"string.h"}})
    configvar_check_cfuncs("HAVE_STRNCPY_S", "strncpy_s", {includes={"string.h"}})
    configvar_check_cfuncs("HAVE_STRNLEN", "strnlen", {includes={"string.h"}})
    configvar_check_cfuncs("HAVE_STRRCHR", "strrchr", {includes={"string.h"}})
    configvar_check_cfuncs("HAVE_SYMLINK", "symlink", {includes={"unistd.h"}})
    configvar_check_cfuncs("HAVE_TIMEGM", "timegm", {includes={"time.h"}})
    configvar_check_cfuncs("HAVE_TZSET", "tzset", {includes={"time.h"}})
    configvar_check_cfuncs("HAVE_UNLINKAT", "unlinkat", {includes={"fcntl.h", "sys/stat.h"}})
    configvar_check_cfuncs("HAVE_UNSETENV", "unsetenv", {includes={"stdlib.h"}})
    configvar_check_cfuncs("HAVE_UTIME", "utime", {includes={"utime.h"}})
    configvar_check_cfuncs("HAVE_UTIMES", "utimes", {includes={"sys/time.h"}})
    configvar_check_cfuncs("HAVE_UTIMENSAT", "utimensat", {includes={"fcntl.h", "sys/stat.h"}})
    configvar_check_cfuncs("HAVE_VFORK", "vfork", {includes={"unistd.h"}})
    configvar_check_cfuncs("HAVE_WCRTOMB", "wcrtomb", {includes={"wchar.h"}})
    configvar_check_cfuncs("HAVE_WCSCMP", "wcscmp", {includes={"wchar.h"}})
    configvar_check_cfuncs("HAVE_WCSCPY", "wcscpy", {includes={"wchar.h"}})
    configvar_check_cfuncs("HAVE_WCSLEN", "wcslen", {includes={"wchar.h"}})
    configvar_check_cfuncs("HAVE_WCTOMB", "wctomb", {includes={"wchar.h"}})
    configvar_check_cfuncs("HAVE__CTIME64_S", "_ctime64_s", {includes={"time.h"}})
    configvar_check_cfuncs("HAVE__FSEEKI64", "_fseeki64", {includes={"stdio.h"}})
    configvar_check_cfuncs("HAVE__GET_TIMEZONE", "_get_timezone", {includes={"time.h"}})
    configvar_check_cfuncs("HAVE__GMTIME64_S", "_gmtime64_s", {includes={"time.h"}})
    configvar_check_cfuncs("HAVE__LOCALTIME64_S", "_localtime64_s", {includes={"time.h"}})
    configvar_check_cfuncs("HAVE__MKGMTIME64", "_mkgmtime64", {includes={"time.h"}})

    configvar_check_cfuncs("HAVE_CYGWIN_CONV_PATH", "cygwin_conv_path", {includes={"sys/cygwin.h"}})
    configvar_check_cfuncs("HAVE_FSEEKO", "fseeko" , {includes={"stdio.h"}})
    configvar_check_cfuncs("HAVE_STRERROR_R", "strerror_r", {includes={"string.h"}})
    configvar_check_cfuncs("HAVE_DECL_STRERROR_R", "strerror_r", {includes={"string.h"}})
    configvar_check_cfuncs("HAVE_STRFTIME", "strftime", {includes={"time.h"}})
    configvar_check_cfuncs("HAVE_VPRINTF", "vprintf", {includes={"stdio.h"}})
    configvar_check_cfuncs("HAVE_WMEMCMP", "wmemcmp", {includes={"wchar.h"}})
    configvar_check_cfuncs("HAVE_WMEMCPY", "wmemcpy", {includes={"wchar.h"}})
    configvar_check_cfuncs("HAVE_WMEMMOVE", "wmemmove", {includes={"wchar.h"}})
    configvar_check_cfuncs("HAVE_DIRFD", "dirfd", {includes={"dirent.h"}})
    configvar_check_cfuncs("HAVE_READLINKAT", "readlinkat", {includes={"unistd.h"}})

    configvar_check_has_member("HAVE_STRUCT_TM_TM_GMTOFF", "struct tm", "tm_gmtoff", {includes={"time.h"}})
    configvar_check_has_member("HAVE_STRUCT_TM___TM_GMTOFF", "struct tm", "__tm_gmtoff", {includes={"time.h"}})
    configvar_check_has_member("HAVE_STRUCT_STATFS_F_NAMEMAX", "struct statfs", "f_namemax", {includes={"sys/param.h","sys/mount.h"}})
    configvar_check_has_member("HAVE_STRUCT_STATFS_F_IOSIZE", "struct statfs", "f_iosize", {includes={"sys/param.h","sys/mount.h"}})
    configvar_check_has_member("HAVE_STRUCT_STAT_ST_BIRTHTIME", "struct stat", "st_birthtime", {includes={"sys/types.h","sys/stat.h"}})
    configvar_check_has_member("HAVE_STRUCT_STAT_ST_BIRTHTIMESPEC_TV_NSEC", "struct stat", "st_birthtimespec.tv_nsec", {includes={"sys/types.h","sys/stat.h"}})
    configvar_check_has_member("HAVE_STRUCT_STAT_ST_MTIMESPEC_TV_NSEC", "struct stat", "st_mtimespec.tv_nsec", {includes={"sys/types.h","sys/stat.h"}})
    configvar_check_has_member("HAVE_STRUCT_STAT_ST_MTIM_TV_NSEC", "struct stat", "st_mtim.tv_nsec", {includes={"sys/types.h","sys/stat.h"}})
    configvar_check_has_member("HAVE_STRUCT_STAT_ST_MTIME_N", "struct stat", "st_mtime_n", {includes={"sys/types.h","sys/stat.h"}})
    configvar_check_has_member("HAVE_STRUCT_STAT_ST_UMTIME", "struct stat", "st_umtime", {includes={"sys/types.h","sys/stat.h"}})
    configvar_check_has_member("HAVE_STRUCT_STAT_ST_MTIME_USEC", "struct stat", "st_mtime_usec", {includes={"sys/types.h","sys/stat.h"}})
    configvar_check_has_member("HAVE_STRUCT_STAT_ST_BLKSIZE", "struct stat", "st_blksize", {includes={"sys/types.h","sys/stat.h"}})
    configvar_check_has_member("HAVE_STRUCT_STAT_ST_FLAGS", "struct stat", "st_flags", {includes={"sys/types.h","sys/stat.h"}})
    configvar_check_has_member("TIME_WITH_SYS_TIME", "struct tm", "tm_sec", {includes={"sys/types.h","sys/time.h","time.h"}})
    configvar_check_has_member("HAVE_STRUCT_STATVFS_F_IOSIZE", "struct statvfs", "f_iosize", {includes={"sys/types.h","sys/statvfs.h"}})

    configvar_check_sizeof("SIZEOF_SHORT", "short")
    configvar_check_sizeof("SIZEOF_INT", "int")
    configvar_check_sizeof("SIZEOF_LONG", "long")
    configvar_check_sizeof("SIZEOF_LONG_LONG", "long long")
    configvar_check_sizeof("SIZEOF_UNSIGNED_SHORT", "unsigned short")
    configvar_check_sizeof("SIZEOF_UNSIGNED", "unsigned")
    configvar_check_sizeof("SIZEOF_UNSIGNED_LONG", "unsigned long")
    configvar_check_sizeof("SIZEOF_UNSIGNED_LONG_LONG", "unsigned long long")

    configvar_check_sizeof("__INT64", "__int64")
    configvar_check_sizeof("UNSIGNED___INT64", "unsigned __int64")
    configvar_check_sizeof("INT16_T", "int16_t")
    configvar_check_sizeof("INT32_T", "int32_t")
    configvar_check_sizeof("INT64_T", "int64_t")
    configvar_check_sizeof("INTMAX_T", "intmax_t")
    configvar_check_sizeof("UINT8_T", "uint8_t")
    configvar_check_sizeof("UINT16_T", "uint16_t")
    configvar_check_sizeof("UINT32_T", "uint32_t")
    configvar_check_sizeof("UINT64_T", "uint64_t")
    configvar_check_sizeof("UINTMAX_T", "uintmax_t")

    set_configvar("HAVE_LZMA_STREAM_ENCODER_MT", 1)
    -- set_configvar("_FILE_OFFSET_BITS", 1)
    set_configvar("VERSION", "3.6.1")

    add_defines("HAVE_CONFIG_H=1")

    configvar_check_cincludes("HAVE_BCRYPT_H", "Bcrypt.h")
    if is_plat("windows", "mingw") then
        add_syslinks("Bcrypt")
    end

    for _, op in ipairs(options) do
        if has_config(op) then
            add_packages(op)
            if op == "zlib" then
                set_configvar("HAVE_LIBZ", 1)
                set_configvar("HAVE_ZLIB_H", 1)
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
            elseif op == "iconv" then
                set_configvar("HAVE_ICONV_H", 1)
            elseif op == "xml2" then
                set_configvar("HAVE_LIBXML2", 1)
                configvar_check_cincludes("HAVE_LIBXML_XMLREADER_H", "libxml/xmlreader.h")
                configvar_check_cincludes("HAVE_LIBXML_XMLWRITER_H", "libxml/xmlwriter.h")
            elseif op == "expat" then
                set_configvar("HAVE_LIBEXPAT", 1)
                configvar_check_cincludes("HAVE_EXPAT_H", "expat.h")
            end
        end
    end

    for _, f in ipairs(sourceFiles) do
        add_files(path.join("libarchive", f))
    end
