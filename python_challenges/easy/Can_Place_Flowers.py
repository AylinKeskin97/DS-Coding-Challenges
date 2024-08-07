"""
Can Place Flowers
------------------------------------------------------------------------------------------------------------------------
You have a long flowerbed in which some of the plots are planted, and some are not. However, flowers cannot be planted
in adjacent plots.

Given an integer array flowerbed containing 0's and 1's, where 0 means empty and 1 means not empty, and an integer n,
return true if n new flowers can be planted in the flowerbed without violating the no-adjacent-flowers rule and false otherwise.

Example 1:

Input: flowerbed = [1,0,0,0,1], n = 1
Output: true

Example 2:

Input: flowerbed = [1,0,0,0,1], n = 2
Output: false

Constraints:

- 1 <= flowerbed.length <= 2 * 104
- flowerbed[i] is 0 or 1.
- There are no two adjacent flowers in flowerbed.
- 0 <= n <= flowerbed.length
"""
from typing import List

class Solution:
    def canPlaceFlowers(self, flowerbed: List[int], n: int) -> bool:
        # [1,0,0,1,0,0] n = 1 true but n = 2 false
        # [0,0,1,0,1,0,0] n = 1, n = 2 true but n = 3 false
        # [0,1,0,0,0,1,0,0,1]
        i = 0
        while i < len(flowerbed) and n > 0:
            #Check if current flowerbed is empty
            if flowerbed[i] == 0:
                # Check the left and right plots (if they exist)

                # either we are at the beginning or the one before must also be 0
                empty_left = (i == 0 or flowerbed[i - 1] == 0) # bool statement

                #either we are at the end or the one after must also be 0
                empty_right = (i == len(flowerbed) - 1 or flowerbed[i + 1] == 0)

                if empty_left and empty_right:
                    # Plant a flower here
                    flowerbed[i] = 1
                    n -= 1

                    #Skip the next plot as it is adjacent to the current one
                    i += 1
                #Move to the next plot
                i+= 1
        return n == 0

    # Example usage:
solution = Solution()
print(solution.canPlaceFlowers([1,0,0,0,1], 1))  # Output: True
print(solution.canPlaceFlowers([1,0,0,0,1], 2))  # Output: False
print(solution.canPlaceFlowers([0,0,0,0,0], 2))  # Output: True
