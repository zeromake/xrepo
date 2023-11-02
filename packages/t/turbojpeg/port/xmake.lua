includes("@builtin/check")
add_rules("mode.debug", "mode.release")

if is_plat("windows") then
    add_cxflags("/utf-8")
end

option("with_arith")
    set_default(true)
    set_showmenu(true)
option_end()


option("with_java")
    set_default(false)
    set_showmenu(true)
option_end()

option("with_simd")
    set_default(true)
    set_showmenu(true)
option_end()

local JPEG16_SOURCES = {
    "jcapistd.c",
    "jccolor.c",
    "jcdiffct.c",
    "jclossls.c",
    "jcmainct.c",
    "jcprepct.c",
    "jcsample.c",
    "jdapistd.c",
    "jdcolor.c",
    "jddiffct.c",
    "jdlossls.c",
    "jdmainct.c",
    "jdpostct.c",
    "jdsample.c",
    "jutils.c",
}

local JPEG12_SOURCES = table.join(JPEG16_SOURCES, {
    "jccoefct.c",
    "jcdctmgr.c",
    "jdcoefct.c",
    "jddctmgr.c",
    "jdmerge.c",
    "jfdctfst.c",
    "jfdctint.c",
    "jidctflt.c",
    "jidctfst.c",
    "jidctint.c",
    "jidctred.c",
    "jquant1.c",
    "jquant2.c",
})

local JPEG_SOURCES = table.join(JPEG12_SOURCES, {
    "jcapimin.c",
    "jchuff.c",
    "jcicc.c",
    "jcinit.c",
    "jclhuff.c",
    "jcmarker.c",
    "jcmaster.c",
    "jcomapi.c",
    "jcparam.c",
    "jcphuff.c",
    "jctrans.c",
    "jdapimin.c",
    "jdatadst.c",
    "jdatasrc.c",
    "jdhuff.c",
    "jdicc.c",
    "jdinput.c",
    "jdlhuff.c",
    "jdmarker.c",
    "jdmaster.c",
    "jdphuff.c",
    "jdtrans.c",
    "jerror.c",
    "jfdctflt.c",
    "jmemmgr.c",
    "jmemnobs.c",
})

if get_config("with_arith") then
    table.join2(JPEG_SOURCES, {
        "jaricom.c",
        "jcarith.c",
        "jdarith.c"
    })
end

local SIMD_SOURCES = {}

if is_arch("x86_64", "x64") then
    table.join2(SIMD_SOURCES, {
        "x86_64/jsimdcpu.asm",
        "x86_64/jfdctflt-sse.asm",
        "x86_64/jccolor-sse2.asm",
        "x86_64/jcgray-sse2.asm",
        "x86_64/jchuff-sse2.asm",
        "x86_64/jcphuff-sse2.asm",
        "x86_64/jcsample-sse2.asm",
        "x86_64/jdcolor-sse2.asm",
        "x86_64/jdmerge-sse2.asm",
        "x86_64/jdsample-sse2.asm",
        "x86_64/jfdctfst-sse2.asm",
        "x86_64/jfdctint-sse2.asm",
        "x86_64/jidctflt-sse2.asm",
        "x86_64/jidctfst-sse2.asm",
        "x86_64/jidctint-sse2.asm",
        "x86_64/jidctred-sse2.asm",
        "x86_64/jquantf-sse2.asm",
        "x86_64/jquanti-sse2.asm",
        "x86_64/jccolor-avx2.asm",
        "x86_64/jcgray-avx2.asm",
        "x86_64/jcsample-avx2.asm",
        "x86_64/jdcolor-avx2.asm",
        "x86_64/jdmerge-avx2.asm",
        "x86_64/jdsample-avx2.asm",
        "x86_64/jfdctint-avx2.asm",
        "x86_64/jidctint-avx2.asm",
        "x86_64/jquanti-avx2.asm",
    })
elseif is_arch("i386", "x86") then
    table.join2(SIMD_SOURCES, {
        "i386/jsimdcpu.asm",
        "i386/jfdctflt-3dn.asm",
        "i386/jidctflt-3dn.asm",
        "i386/jquant-3dn.asm",
        "i386/jccolor-mmx.asm",
        "i386/jcgray-mmx.asm",
        "i386/jcsample-mmx.asm",
        "i386/jdcolor-mmx.asm",
        "i386/jdmerge-mmx.asm",
        "i386/jdsample-mmx.asm",
        "i386/jfdctfst-mmx.asm",
        "i386/jfdctint-mmx.asm",
        "i386/jidctfst-mmx.asm",
        "i386/jidctint-mmx.asm",
        "i386/jidctred-mmx.asm",
        "i386/jquant-mmx.asm",
        "i386/jfdctflt-sse.asm",
        "i386/jidctflt-sse.asm",
        "i386/jquant-sse.asm",
        "i386/jccolor-sse2.asm",
        "i386/jcgray-sse2.asm",
        "i386/jchuff-sse2.asm",
        "i386/jcphuff-sse2.asm",
        "i386/jcsample-sse2.asm",
        "i386/jdcolor-sse2.asm",
        "i386/jdmerge-sse2.asm",
        "i386/jdsample-sse2.asm",
        "i386/jfdctfst-sse2.asm",
        "i386/jfdctint-sse2.asm",
        "i386/jidctflt-sse2.asm",
        "i386/jidctfst-sse2.asm",
        "i386/jidctint-sse2.asm",
        "i386/jidctred-sse2.asm",
        "i386/jquantf-sse2.asm",
        "i386/jquanti-sse2.asm",
        "i386/jccolor-avx2.asm",
        "i386/jcgray-avx2.asm",
        "i386/jcsample-avx2.asm",
        "i386/jdcolor-avx2.asm",
        "i386/jdmerge-avx2.asm",
        "i386/jdsample-avx2.asm",
        "i386/jfdctint-avx2.asm",
        "i386/jidctint-avx2.asm",
        "i386/jquanti-avx2.asm",
    })
end

target("turbojpeg")
    set_kind("$(kind)")

    add_configfiles("jconfig.h.in")
    add_configfiles("jconfig.h.in")

    add_headerfiles("todo.h")
    for _, f in ipairs(sourceFiles) do
        add_files(f)
    end
