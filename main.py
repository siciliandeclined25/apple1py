import os

import apple1

debugme = (
    True if input("do you want to enable debug mode? (y/n): ").lower() == "y" else False
)
assemblenew = (
    True
    if input("do you want to assemble a new file ? (y/n): ").lower() == "y"
    else False
)
# print(debugme)
# if debugme:
p = apple1.Apple1Py(file="mem.b")
if assemblenew:
    os.system("ls")
    fileTo = input("choose a file to convert> ")
    # fileTo = "asmcode/newconvert.asm"
    p.convert(fileTo, debug=debugme)  # convert to mem.b
p.start(debug=debugme)
