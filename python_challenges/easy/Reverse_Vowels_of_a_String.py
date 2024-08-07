"""
Reverse Vowels of a String
------------------------------------------------------------------------------------------------------------------------
Given a string s, reverse only all the vowels in the string and return it.

The vowels are 'a', 'e', 'i', 'o', and 'u', and they can appear in both lower and upper cases, more than once.

Example 1:

Input: s = "hello"
Output: "holle"

Example 2:

Input: s = "leetcode"
Output: "leotcede"

Constraints:

- 1 <= s.length <= 3 * 105
- s consist of printable ASCII characters.
"""
# ugly solution
class Solution:
    def reverseVowels(self, s: str) -> str:
        vowels = "aeiouAEIOU"  # Include both lowercase and uppercase vowels
        vowels_in_str = []

        # Collect all vowels in the string
        for vow in s:
            if vow in vowels:
                vowels_in_str.append(vow)

        # Reverse the list of collected vowels
        vowels_in_str = vowels_in_str[::-1]

        # Convert the string to a list since strings are immutable
        s = list(s)
        vowel_index = 0

        # Replace the vowels in the original string with the reversed vowels
        for i in range(len(s)):
            if s[i] in vowels:
                s[i] = vowels_in_str[vowel_index]
                vowel_index += 1

        # Convert the list back to a string
        return ''.join(s)

# two pointer solution
class Solution:
    def reverseVowels(self, s: str) -> str:
        # We use a set for vowels (aeiouAEIOU) because checking membership in a set is faster than in a string (O(1) vs. O(n))
        vowels = set("aeiouAEIOU")
        s = list(s)
        left, right = 0, len(s) - 1

        while left < right:
            if s[left] not in vowels:
                left +=1
            elif s[right] not in vowels:
                right -=1
            else:
                s[left], s[right]= s[right], s[left]
                left += 1
                right -= 1

        return "".join(s)
