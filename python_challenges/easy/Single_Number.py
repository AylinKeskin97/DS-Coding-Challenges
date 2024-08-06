"""
Single Number
------------------------------------------------------------------------------------------------------------------------
Given a non-empty array of integers nums, every element appears twice except for one. Find that single one.

You must implement a solution with a linear runtime complexity and use only constant extra space.

Example 1:
Input: nums = [2,2,1]
Output: 1

Example 2:
Input: nums = [4,1,2,1,2]
Output: 4

Example 3:
Input: nums = [1]
Output: 1

Constraints:
1 <= nums.length <= 3 * 104
-3 * 104 <= nums[i] <= 3 * 104

Each element in the array appears twice except for one element which appears only once.
"""
# using a set
from typing import List

class Solution:
    def singleNumber(self, nums: List[int]) -> int:
        seen = set()

        for num in nums:
            if num in seen:
                seen.remove(num)
            else:
                seen.add(num)

        # The single element will be the only element left in the set
        return seen.pop()

# using the XOR operator
class Solution:
    def singleNumber(self, nums: List[int]) -> int:
        result = 0
        for num in nums:
            result ^= num
        return result

# Example usage
solution = Solution()

# Test case 1
print(solution.singleNumber([2, 2, 1]))  # Output: 1

# Test case 2
print(solution.singleNumber([4, 1, 2, 1, 2]))  # Output: 4

# Test case 3
print(solution.singleNumber([1]))  # Output: 1
