extends Node

class_name LInt

var lint: String = ""
const intSizeNames = ["M", "B", "Tr", "Quadr", "Quint", "Sext", "Sept", "Oct", "Non", "Dec", "Undec",
					"Duodec", "Tredec", "Quattuordec", "Quindec", "Sexdec", "Septendec", "Octodec", 
					"Novemdec", "Vigint", "Cent"]

#Max amount each List<int> can be
#We take 1 for if theres a digit added to the front
#Then 2 for if theres a decimal added
var intMaxChar = 19 - 3#9,223,372,036,854,775,807
	
func Add(value):
	var curs = makeArraysEqual(ConvertToInts(), value)
	
	for count in curs[0].size():
		#If last item in array to 2 decimals
		if(count == curs[0].size()-1):
			Round(curs[0][count])
			Round(curs[1][count])
		
		curs[0][count] += curs[1][count]
		pass
	
	lint = ConvertToString(curs[0])
	pass
	
	
func Minus(value):
	var curs = makeArraysEqual(ConvertToInts(), value)
	
	#Find which number is greater
	var isGreaterThan = IsGreaterThan(curs[1], curs[0])
	
	#Subtract the base larger number from the smaller
	var newCur = []
	for count in curs[0].size():
		#If last item in array round to 2 decimals
		if(count == curs[0].size()-1):
			Round(curs[0][count])
			Round(curs[1][count])
		
		#If list1 is larger of it their equal
		if isGreaterThan || isGreaterThan == null:
			var newVal = curs[0][count] - curs[1][count]
			
			#Theres a chance we have a negative number correct that here
			if(newVal < 0):
				newCur[count-1] - 1
				newVal = (10 ** (intMaxChar+1)) - newVal
			
			newCur.append(newVal)
		else:#If List2 is larger
			var newVal = curs[1][count] - curs[0][count]
			
			#Theres a chance we have a negative number correct that here
			if(newVal < 0):
				newCur[count-1] - 1
				newVal = (10 ** (intMaxChar+1)) - newVal
			
			newCur.append(newVal)
		pass
	
	lint = ConvertToString(newCur)
	pass
	

func Mul(value):
	var listInts = ConvertToInts()
	for count in listInts.size():
		listInts[count] *= value
		pass
	
	for count in listInts.size():
		#If the value is greater than
		if(listInts[count] > 10.00 ** intMaxChar && count != 0):
			listInts[count] -= (10.00 ** (intMaxChar+1))
			listInts[count - 1] += 1.00
			
		#If the value isnt the last in the list and has a decimal
		#Remove the decimal and add the amount to the next row
		if(str(listInts[count]).find(".") && count != listInts.size()-1):
			var dec = listInts[count] - listInts[count]
			var toAdd = dec * 10.00 ** intMaxChar
			
			listInts[count] = listInts[count]
			listInts[count+1] += toAdd
			pass
		pass
	
	lint = ConvertToString(listInts)
	pass
	
#Theres no easy way to divide two lists
#The first elm is over 100t
#Just divide the first elm and use that since where not setting the value
func Divide(value: Array):
	var array1 = ConvertToInts()
	var arrays = makeArraysEqual(array1, value)
	
	#Divide byt the larger then floor the result
	var result = (arrays[0][0] / arrays[1][0]) if IsGreaterThan(value) else (arrays[1][0] / arrays[0][0])
	return floor(result)
	pass

#Converts a list of ints to a string
func ConvertToString(value):
	var newCur = ""
	for subCur in value:
		newCur += str(subCur)
	
	return newCur
	
	pass


#Converts to a list of ints
func ConvertToInts():	
	var curList = []
	var count = 1
	var segments = lint.length() / intMaxChar
	
	if segments == 0:
		curList.append(float(lint))
	
	for currency in segments:
		var startPos = (count - 1) * intMaxChar
		var length = intMaxChar * count
		var subCur = lint.substr(startPos, length)
		curList.append(float(subCur))
		count += 1
	
	return curList
	pass
	
#
func makeArraysEqual(array1: Array, array2: Array):
	var a1Size =  array1.size()
	var a2Size =  array2.size()
	
	#insert an empty element infront of the smaller 
	#array till the size is equal
	if a1Size > a2Size:
		for dif in a1Size - a2Size:
			array2.insert(0, 0)
	else:
		for dif in a2Size - a1Size:
			array1.insert(0, 0)
			
	return [array1, array2]
	

func IsGreaterThan(array2: Array, array1 = ConvertToInts()):
	#Find which number is greater
	var largerNumber = null
	
	#First compare the size of the two arrays
	#If theres a size difference return as best fit
	if array1.size() > array2.size():
		return true
	elif array2.size() > array1.size():
		return false
	
	#The arrays must be the same size
	#Figure out which is larger
	for count in array1.size():
		#Once we found one greater don't continue
		if largerNumber != null:
			continue
		
		#Compare and find the larger number
		if array1[count] > array2[count]:
			largerNumber = true
		elif array2[count] > array1[count]:
			largerNumber = false
			
	#If we get to this point and were unchanged they must be equal
	#Return true in this case
	if largerNumber == null:
		largerNumber = true
	
	return largerNumber
	pass

	
func Round(value):
	return round(value * pow(10.0, 2)) / pow(10.0, 2)


#Converts the string value into a more managable form to be seen by the user
func ToDisplayValue():
	if lint == "0":
		return "0"
	
	#Get the number scale 
	var pos: float
	pos = str(floor(float(lint))).length() / 3.00
	
	#If the number is bellow 1millon return the number
	if(pos <= 2):
		return str(lint)
	
	var sufix = "illion"
	var prefix = intSizeNames[ceil(pos)-3]
	var numName = str(prefix, sufix)
	var mod = fmod(pos, 3.00)
	
	var len = 6#100
	#If the pos is not divisable by 3 then calculate where to split
	if mod != 0:
		var val = str(mod).substr(2, 1)
		if val == "6":
			len = 5#10
			pass
		elif val == "3":
			len = 4#1
			pass
		
	var number = lint.substr(0, len)
	var inPos = 6-len
	
	return str(number, " ", numName).insert(3 - inPos, ".")
	
	pass
