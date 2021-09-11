def capitalize_first_char(string):
    if len(string) == 0:
        return string
    if len(string) == 1:
        return string.upper()
    return string[0].upper() + string[1:]

def replace_extension(string, old_extension, new_extension, suffix = ""):
    return string.rpartition(old_extension)[0][:-1] + suffix + "." + new_extension
