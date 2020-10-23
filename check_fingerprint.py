import subprocess, os, string, time, sys
from typing import List


def sschenk_fingerprint(self):
    a = sys.argv
    a = (list(a))
    print(len(a))
    for i in a:
        print(i)
    #   print(" ")
    # devicesID=sys.argv[1]
    devicesID = []
    text = []
    text2 = []
    k = 2
    for i in ((a)):
        # print(str(i) )
        devicesID.append(i)
        k = k + i
    print(devicesID[2] + "hheheheheh")
    for i in devicesID:
        # print(i)
        print("")
    output1 = subprocess.check_output(("adb -s 872HADSR4DKRH shell getprop | grep fingerprint").split("\n"), shell=True)
    output2 = subprocess.check_output(("adb -s 1895110299 shell getprop | grep fingerprint").split("\n"), shell=True)

    for word in output1.split():
        text.append(str(word))
    # text2.append(str(word))

    for word in output2.split():
        # text.append(str(word))
        text2.append(str(word))

    text2.append("ohohohohohohohoh")

    # print((str(text)) + "ttttttttttttttttttt")
    # print((list(text)[0]) + "GGGGGGGGGGGGGGGGGGGG")
    k = 0
    s1 = set(text)
    s2 = set(text2)
    print(s1.symmetric_difference(s2))  # 字串比較
    for i in text:
        # print( str(k) + " " + (i) )
        k = k + 1

def chenk_fingerprint(self):
    print(self.serialID)

if __name__ == '__main__':
    os.system("python /CTS_tool/CTSV/3PL_verifier/verifier.py")