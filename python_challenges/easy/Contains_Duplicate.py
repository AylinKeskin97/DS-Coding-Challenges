"""
Contains Duplicate
------------------------------------------------------------------------------------------------------------------------
Given an integer array nums, return true if any value appears at least twice in the array, and return false if every element is distinct.

Example 1:
Input: nums = [1,2,3,1]
Output: true

Example 2:
Input: nums = [1,2,3,4]
Output: false

Example 3:
Input: nums = [1,1,1,3,3,4,3,2,4,2]
Output: true

Constraints:
1 <= nums.length <= 105
-109 <= nums[i] <= 109
"""
from typing import List

class Solution:
    def containsDuplicate(self, nums: List[int]) -> bool:
        seen = set()  # Initialize an empty set to keep track of seen elements

        for num in nums:
            if num in seen:
                return True  # Found a duplicate
            seen.add(num)  # Add the element to the set

        return False  # No duplicates found

# Example usage
solution = Solution()

# Test case 1
print(solution.containsDuplicate([1, 2, 3, 1]))  # Output: true

# Test case 2
print(solution.containsDuplicate([1, 2, 3, 4]))  # Output: false

# Test case 3
print(solution.containsDuplicate([1, 1, 1, 3, 3, 4, 3, 2, 4, 2]))  # Output: true
