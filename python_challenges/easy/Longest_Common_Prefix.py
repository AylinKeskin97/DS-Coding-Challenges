
"""
Longest Common Prefix
------------------------------------------------------------------------------------------------------------------------
Write a function to find the longest common prefix string amongst an array of strings.

If there is no common prefix, return an empty string "".



Example 1:

Input: strs = ["flower","flow","flight"]
Output: "fl"
Example 2:

Input: strs = ["dog","racecar","car"]
Output: ""
Explanation: There is no common prefix among the input strings.


Constraints:

1 <= strs.length <= 200
0 <= strs[i].length <= 200
strs[i] consists of only lowercase English letters.
"""
from typing import List

class Solution:
    def longestCommonPrefix(self, strs: List[str]) -> str:
        # Edge case: if the input list is empty, return an empty string
        if not strs:
            return ""

        # Sort the array
        #The first string (strs[0]) and the last string (strs[-1]) will have the smallest and largest lexicographical
        # differences in the array.
        #Therefore, the common prefix of the entire array must be a prefix of both the first and the last strings.
        # Any common prefix found between these two will be the common prefix for the whole array.
        strs.sort()

        # Compare the first and the last strings in the sorted array
        first, last = strs[0], strs[-1]
        i = 0

        # Find the common prefix between the first and last string
        while i < len(first) and i < len(last) and first[i] == last[i]:
            i += 1

        # The common prefix
        return first[:i]

# Example usage
solution = Solution()
print(solution.longestCommonPrefix(["flower", "flow", "flight"]))  # Output: "fl"
print(solution.longestCommonPrefix(["dog", "racecar", "car"]))    # Output: ""
