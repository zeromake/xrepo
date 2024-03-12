function CheckAsmPlat()
    local check = {
        HOST_ENABLE_ASM = true,
        HOST_ASM_MACOSX_X86_64 = false,
        HOST_ASM_MASM_X86_64 = false,
        HOST_ASM_MINGW64_X86_64 = false,
        HOST_ASM_ELF_X86_64 = false,
        HOST_ASM_ELF_ARMV4 = false
    }
    if get_config("asm") then
        if is_plat("macosx") and is_arch("x64", "x86_64") then
            check.HOST_ASM_MACOSX_X86_64 = true
        elseif is_plat("windows") and is_arch("x64", "x86_64") then
            check.HOST_ASM_MASM_X86_64 = true
        elseif is_plat("mingw") and is_arch("x64", "x86_64") then
            check.HOST_ASM_MINGW64_X86_64 = true
        else
            if is_arch("x64", "x86_64") then
                check.HOST_ASM_ELF_X86_64 = true
            elseif is_arch("arm.*") or is_arch("arm64.*") then
                check.HOST_ASM_ELF_ARMV4 = true
            else
                check.HOST_ENABLE_ASM = false
            end
        end
    else
        check.HOST_ENABLE_ASM = false
    end
    return check
end
