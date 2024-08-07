"""
Move Zeroes
------------------------------------------------------------------------------------------------------------------------
Given an integer array nums, move all 0's to the end of it while maintaining the relative order of the non-zero elements.

Note that you must do this in-place without making a copy of the array.

Example 1:

Input: nums = [0,1,0,3,12]
Output: [1,3,12,0,0]

Example 2:

Input: nums = [0]
Output: [0]

Constraints:

1 <= nums.length <= 104
-231 <= nums[i] <= 231 - 1

Follow up: Could you minimize the total number of operations done?
"""
from typing import List

class Solution:
    def moveZeroes(self, nums: List[int]) -> None:
        last_non_zero_found_at = 0

        # Move all non-zero elements to the front
        for i in range(len(nums)):
            if nums[i] != 0:
                #This pointer starts at the beginning of the array. As we iterate through the array,
                # every time we encounter a non-zero element, it is placed at the position last_non_zero_found_at,
                # and this pointer is incremented.
                nums[last_non_zero_found_at], nums[i] = nums[i], nums[last_non_zero_found_at]
                last_non_zero_found_at += 1

        # After all non-zero elements are at the beginning, remaining elements will be zeroes
        # No need to fill in the zeroes manually because they are already in place due to the swap

# Example usage:
solution = Solution()
nums1 = [0, 1, 0, 3, 12]
solution.moveZeroes(nums1)
print(nums1)  # Output: [1, 3, 12, 0, 0]

nums2 = [0]
solution.moveZeroes(nums2)
print(nums2)  # Output: [0]
