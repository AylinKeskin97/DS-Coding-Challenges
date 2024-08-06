"""
Palindrome Number
------------------------------------------------------------------------------------------------------------------------
Given an integer x, return true if x is a palindrome, and false otherwise.

Example 1:

Input: x = 121
Output: true
Explanation: 121 reads as 121 from left to right and from right to left.
Example 2:

Input: x = -121
Output: false
Explanation: From left to right, it reads -121. From right to left, it becomes 121-. Therefore it is not a palindrome.
Example 3:

Input: x = 10
Output: false
Explanation: Reads 01 from right to left. Therefore it is not a palindrome.


Constraints:
-231 <= x <= 231 - 1

Follow up: Could you solve it without converting the integer to a string?
"""
#converting it into a string
class Solution:
    def isPalindrome(self, x: int) -> bool:
        # Negative numbers are not palindromes
        if x < 0:
            return False

        x_str = str(x)

        x_reversed = x_str[::-1]

        return x_str == x_reversed

#without string conversion
class Solution:
    def isPalindrome(self, x: int) -> bool:
        # Negative numbers cannot be palindromes
        if x < 0:
            return  False

        if x % 10 == 0 and x != 0:
            return False

        reversed_half = 0
        while x > reversed_half:
            reversed_half = reversed_half * 10 + x % 10
            x //= 10

        # When the lenght is odd, we can ignore the midlle digit by reversed_half // 10
        return x == reversed_half or x == reversed_half // 10

# Example usage
solution = Solution()
print(solution.isPalindrome(121))  # Output: True
print(solution.isPalindrome(-121)) # Output: False
print(solution.isPalindrome(10))   # Output: False
print(solution.isPalindrome(12321)) # Output: True
