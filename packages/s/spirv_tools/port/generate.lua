local GRAMMAR_PROCESSING_SCRIPT = "./utils/generate_grammar_tables.py"
local VIMSYNTAX_PROCESSING_SCRIPT = "./utils/generate_vim_syntax.py"
local XML_REGISTRY_PROCESSING_SCRIPT = "./utils/generate_registry_tables.py"
local LANG_HEADER_PROCESSING_SCRIPT = "./utils/generate_language_headers.py"

local DEBUGINFO_GRAMMAR_JSON_FILE = "spirv/unified1/extinst.debuginfo.grammar.json"
local CLDEBUGINFO100_GRAMMAR_JSON_FILE = "spirv/unified1/extinst.opencl.debuginfo.100.grammar.json"
local VKDEBUGINFO100_GRAMMAR_JSON_FILE = "spirv/unified1/extinst.nonsemantic.shader.debuginfo.100.grammar.json"


local function spvtools_core_tables(config, version)
    local spirv_header_includedir = config.spirv_header_includedir
    local buildir = config.buildir
    local core_path = path.join(buildir, "core.insts-"..version..".inc")
    local argv = {
        GRAMMAR_PROCESSING_SCRIPT,
        "--spirv-core-grammar="..path.join(spirv_header_includedir, "spirv/"..version.."/spirv.core.grammar.json"),
        "--extinst-debuginfo-grammar="..path.join(spirv_header_includedir, DEBUGINFO_GRAMMAR_JSON_FILE),
        "--extinst-cldebuginfo100-grammar="..path.join(spirv_header_includedir, CLDEBUGINFO100_GRAMMAR_JSON_FILE),
        "--core-insts-output="..core_path,
        "--operand-kinds-output="..path.join(buildir, "operand.kinds-"..version..".inc"),
        "--output-language=c++",
    }
    if not os.exists(core_path) then
        os.vexecv("python3", argv)
    end
end

local function spvtools_enum_string_mapping(config, version)
    local spirv_header_includedir = config.spirv_header_includedir
    local buildir = config.buildir
    local extension_enum_path = path.join(buildir, "extension_enum.inc")
    local argv = {
        GRAMMAR_PROCESSING_SCRIPT,
        "--spirv-core-grammar="..path.join(spirv_header_includedir, "spirv/"..version.."/spirv.core.grammar.json"),
        "--extinst-debuginfo-grammar="..path.join(spirv_header_includedir, DEBUGINFO_GRAMMAR_JSON_FILE),
        "--extinst-cldebuginfo100-grammar="..path.join(spirv_header_includedir, CLDEBUGINFO100_GRAMMAR_JSON_FILE),
        "--extension-enum-output="..extension_enum_path,
        "--enum-string-mapping-output="..path.join(buildir, "enum_string_mapping.inc"),
        "--output-language=c++",
    }
    if not os.exists(extension_enum_path) then
        os.vexecv("python3", argv)
    end
end

local function spvtools_opencl_tables(config, version)
    local spirv_header_includedir = config.spirv_header_includedir
    local buildir = config.buildir
    local OPENCL_GRAMMAR_JSON_FILE = path.join(spirv_header_includedir, "spirv/"..version.."/extinst.opencl.std.100.grammar.json")
    local GRAMMAR_INC_FILE = path.join(buildir, "opencl.std.insts.inc")
    local argv = {
        GRAMMAR_PROCESSING_SCRIPT,
        "--extinst-opencl-grammar="..OPENCL_GRAMMAR_JSON_FILE,
        "--opencl-insts-output="..GRAMMAR_INC_FILE,
    }
    if not os.exists(GRAMMAR_INC_FILE) then
        os.vexecv("python3", argv)
    end
end

local function spvtools_glsl_tables(config, version)
    local spirv_header_includedir = config.spirv_header_includedir
    local buildir = config.buildir
    local GLSL_GRAMMAR_JSON_FILE = path.join(spirv_header_includedir, "spirv/"..version.."/extinst.glsl.std.450.grammar.json")
    local GRAMMAR_INC_FILE = path.join(buildir, "glsl.std.450.insts.inc")
    local argv = {
        GRAMMAR_PROCESSING_SCRIPT,
        "--extinst-glsl-grammar="..GLSL_GRAMMAR_JSON_FILE,
        "--glsl-insts-output="..GRAMMAR_INC_FILE,
        "--output-language=c++",
    }
    if not os.exists(GRAMMAR_INC_FILE) then
        os.vexecv("python3", argv)
    end
end

local function spvtools_vendor_tables(config, vendov_table, short_name, operand_kind_prefix)
    operand_kind_prefix = operand_kind_prefix or ""
    local spirv_header_includedir = config.spirv_header_includedir
    local buildir = config.buildir
    local INSTS_FILE = path.join(buildir, vendov_table..".insts.inc")
    local GRAMMAR_FILE = path.join(spirv_header_includedir, "spirv/unified1/extinst."..vendov_table..".grammar.json")
    local argv = {
        GRAMMAR_PROCESSING_SCRIPT,
        "--extinst-vendor-grammar="..GRAMMAR_FILE,
        "--vendor-insts-output="..INSTS_FILE,
        "--vendor-operand-kind-prefix="..operand_kind_prefix,
    }
    if not os.exists(INSTS_FILE) then
        os.vexecv("python3", argv)
    end
end

local function spvtools_extinst_lang_headers(config, name, grammar_file)
    local spirv_header_includedir = config.spirv_header_includedir
    local buildir = config.buildir
    local OUT_H = path.join(buildir, name..".h")
    local argv = {
        LANG_HEADER_PROCESSING_SCRIPT,
        "--extinst-grammar="..path.join(spirv_header_includedir, grammar_file),
        "--extinst-output-path="..OUT_H,
    }
    if not os.exists(OUT_H) then
        os.vexecv("python3", argv)
    end
end

local function spvtools_vimsyntax(config, config_version)
    local spirv_header_includedir = config.spirv_header_includedir
    local buildir = config.buildir
    local GRAMMAR_JSON_FILE = path.join(spirv_header_includedir, "spirv", config_version, "spirv.core.grammar.json")
    local GLSL_GRAMMAR_JSON_FILE = path.join(spirv_header_includedir, "spirv", config_version, "extinst.glsl.std.450.grammar.json")
    local OPENCL_GRAMMAR_JSON_FILE = path.join(spirv_header_includedir, "spirv", config_version, "extinst.opencl.std.100.grammar.json")
    local VIMSYNTAX_FILE = path.join(buildir, "spvasm.vim")
    local argv = {
        VIMSYNTAX_PROCESSING_SCRIPT,
        "--spirv-core-grammar="..GRAMMAR_JSON_FILE,
        "--extinst-debuginfo-grammar="..path.join(spirv_header_includedir, DEBUGINFO_GRAMMAR_JSON_FILE),
        "--extinst-glsl-grammar="..GLSL_GRAMMAR_JSON_FILE,
        "--extinst-opencl-grammar="..OPENCL_GRAMMAR_JSON_FILE,
    }
    if not os.exists(VIMSYNTAX_FILE) then
        local outdata, _ = os.iorunv("python3", argv)
        io.writefile(VIMSYNTAX_FILE, outdata, {encoding = "binary"})
    end
end

local function spvtools_registry_generators(config)
    local spirv_header_includedir = config.spirv_header_includedir
    local buildir = config.buildir
    local GENERATOR_INC_FILE = path.join(buildir, "generators.inc")
    local SPIRV_XML_REGISTRY_FILE = path.join(spirv_header_includedir, "spirv/spir-v.xml")
    local argv = {
        XML_REGISTRY_PROCESSING_SCRIPT,
        "--xml="..SPIRV_XML_REGISTRY_FILE,
        "--generator-output="..GENERATOR_INC_FILE,
    }
    if not os.exists(GENERATOR_INC_FILE) then
        os.vexecv("python3", argv)
    end
end

local function generate_build_version(config)
    local buildir = config.buildir
    local build_version_path = path.join(buildir, "build-version.inc")
    local argv = {
        "./utils/update_build_version.py",
        "CHANGES",
        build_version_path,
    }
    if not os.exists(build_version_path) then
        os.vexecv("python3", argv)
    end
end

local function generate_protobuf(config)
    local buildir = config.buildir
    local PROTOBUF_SOURCE = "source/fuzz/protobufs/spvtoolsfuzz.proto"
    local argv = {
        "-I=source/fuzz/protobufs",
        "--cpp_out=source/fuzz/protobufs",
        PROTOBUF_SOURCE,
    }
    os.vexecv("protoc", argv)
end

function main(target)
    local pkgs = target:pkgs()
    local spirv_headers = pkgs["spirv_headers"]
    local buildir = vformat("$(buildir)")
    local config = {
        buildir = buildir,
        spirv_header_includedir = spirv_headers:get("sysincludedirs")
    }
    spvtools_core_tables(config, "unified1")
    spvtools_enum_string_mapping(config, "unified1")
    spvtools_opencl_tables(config, "unified1")
    spvtools_glsl_tables(config, "unified1")
    spvtools_vendor_tables(config, "spv-amd-shader-explicit-vertex-parameter", "spv-amd-sevp")
    spvtools_vendor_tables(config, "spv-amd-shader-trinary-minmax", "spv-amd-stm")
    spvtools_vendor_tables(config, "spv-amd-gcn-shader", "spv-amd-gs")
    spvtools_vendor_tables(config, "spv-amd-shader-ballot", "spv-amd-sb")
    spvtools_vendor_tables(config, "debuginfo", "debuginfo")
    spvtools_vendor_tables(config, "opencl.debuginfo.100", "cldi100", "CLDEBUG100_")
    spvtools_vendor_tables(config, "nonsemantic.shader.debuginfo.100", "shdi100", "SHDEBUG100_")
    spvtools_vendor_tables(config, "nonsemantic.clspvreflection", "clspvreflection")

    spvtools_extinst_lang_headers(config, "DebugInfo", DEBUGINFO_GRAMMAR_JSON_FILE)
    spvtools_extinst_lang_headers(config, "OpenCLDebugInfo100", CLDEBUGINFO100_GRAMMAR_JSON_FILE)
    spvtools_extinst_lang_headers(config, "NonSemanticShaderDebugInfo100", VKDEBUGINFO100_GRAMMAR_JSON_FILE)

    spvtools_vimsyntax(config, "unified1", "1.0")
    spvtools_registry_generators(config)
    generate_build_version(config)
    generate_protobuf(config)
end
