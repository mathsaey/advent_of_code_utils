# Don't warn on module redefinition
Code.put_compiler_option(:ignore_module_conflict, true)
ExUnit.start()
