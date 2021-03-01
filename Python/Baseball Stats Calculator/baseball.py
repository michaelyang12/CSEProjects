import re, sys, os

if len(sys.argv) < 2:
   sys.exit(f"Usage: {sys.argv[0]} needs input filename")
filename = sys.argv[1]
if not os.path.exists(filename):
   sys.exit(f"Error: File '{sys.argv[1]}' not found")
#filename = "cardinals-1940.txt"
playerData = {}
class name:
    regex = re.compile(r"([A-Z]{1,}[a-z]{1,}\s[A-Z]{1,}.+)\sbatted")
class bat:
    regex = re.compile(r"batted\s(\d)\stimes")
class hit:
    regex = re.compile(r"with\s(\d)\shits")
    
class player(object):
    def __init__(self, playerName):
        self.name = playerName
        self.bats = 0.0
        self.hits = 0.0
        self.avg = 0.0

#go through each line in file and get player name, bats, and hits
with open(filename) as file:
    for line in file:
        strip = line.strip()
        #No NoneType error
        if name.regex.search(strip) is not None:
            pName = str(name.regex.search(strip).group(1))
            pBats = float(bat.regex.search(strip).group(1))
            pHits = float(hit.regex.search(strip).group(1))
            #if player is in dictionary already, add batting and hitting data and calculate average
            if pName in playerData:
                playerData[pName].bats += pBats
                playerData[pName].hits += pHits
                playerData[pName].avg = round(playerData[pName].hits/playerData[pName].bats, 3)
            #if player is not in dictionary already, add player
            else:
                p = player(pName)
                p.bats = pBats
                p.hits = pHits
                p.avg = 0.0
                playerData[pName] = p
#Sorting
if playerData is not None:
    for name in playerData:
        for name2 in playerData:
            if playerData[name].avg > playerData[name2].avg:
                temp = playerData[name]
                playerData[name] = playerData[name2]
                playerData[name2] = temp

#printing to output file
outputName = "output.txt"
outputFile = open(outputName, "w")
if playerData is not None:
    for name in playerData:
        player = playerData[name]
        outputFile.write(str(player.name + ": " + str('%.3f' % player.avg) + "\n"))
    outputFile.close()

if playerData is not None:
    for name in playerData:
        player = playerData[name]
        print(str(player.name + ": " + str('%.3f' % player.avg)))