
import UIKit
// Write a function that returns all the odd elements of an array

// BONUS POINT - Allen is the snapchat Power User!

var elementsArray = [Int]()

for i in 1...50
{
    elementsArray.append(i)
}

func oddElements(array: [Int]) -> [Int]?
{
var returnOdd = [Int]()
    for odd in array
    {
        if odd % 2 != 0
        {
        returnOdd.append(odd)
        }
    }
    return returnOdd
}

oddElements(elementsArray)