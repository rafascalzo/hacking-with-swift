import UIKit

var str = "Hello, playground"

let name = "Frajola"

for letter in name {
    print("letter: \(letter)")
}

// we can’t read individual letters from the string. So, this kind of code won’t work:
// print(name[0])

// The reason for this is that letters in a string aren’t just a series of alphabetical characters – they can contain accents such as á, é, í, ó, or ú, they can contain combining marks that generate wholly new characters by building up symbols, or they can even be emoji.

//Because of this, if you want to read the fourth character of name you need to start at the beginning and count through each letter until you come to the one you’re looking for:

let letter = name[name.index(name.startIndex, offsetBy: 3)]

print(letter)

extension String {
    subscript(i: Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }
    subscript(char: String) -> String {
        return self.appending(" \(char)")
    }
}

print(name[3])

print(name["jaiminho"]["mousex"]["camelódromo"])

//With that in place, we can now read name[3] just fine. However, it creates the possibility that someone might write code that loops over a string reading individual letters, which they might not realize creates a loop within a loop and has the potential to be slow.

//Similarly, reading name.count isn’t a quick operation: Swift literally needs to go over every letter counting up however many there are, before returning that. As a result, it’s always better to use someString.isEmpty rather than someString.count == 0 if you’re looking for an empty string.

let password = "12345"

print(password.hasPrefix("123"))
print(password.hasSuffix("345"))

extension String {
    // remove a prefix if it exist
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    
    // remove a suffix if it exist
    func deletingSuffix(_ suffix: String) -> String {
        guard self.hasSuffix(suffix) else { return self }
        return String(self.dropLast(suffix.count))
    }
}
// That uses the dropFirst() and dropLast() method of String, which removes a certain number of letters from either end of the string.

// print("macarraoboy".deletingPrefix("macarrao"))
print("macarraoBoy".deletingSuffix("Boy"))

print("it's going to rain".capitalized)

extension String {
    var capitalizedFirst: String {
        guard let firstLetter = self.first else { return "" }
        return firstLetter.uppercased() + self.dropFirst()
    }
}

print("it's going to rain".capitalizedFirst)

// One thing you can’t see in that is an interesting subtlety of working with strings: individual letters in strings aren’t instances of String, but are instead instances of Character – a dedicated type for holding single-letters of a string.

// So, that uppercased() method is actually a method on Character rather than String. However, where things get really interesting is that Character.uppercased() actually returns a string, not an uppercased Character. The reason is simple: language is complicated, and although many languages have one-to-one mappings between lowercase and uppercase characters, some do not.

// For example, in English “a” maps to “A”, “b” to “B”, and so on, but in German “ß” becomes “SS” when uppercased. “SS” is clearly two separate letters, so uppercased() has no choice but to return a string.

let input = "Swift is like Objective-C without C"
print(input.contains("Swift"))

let languages = ["Python","Ruby","Swift"]
print(languages.contains("Swift"))

extension String {
    
    func containsAny(of array: [String]) -> Bool {
        for item in array {
            if self.contains(item) {
               return true
            }
        }
        return false
    }
}

print(input.containsAny(of: languages))

// That certainly works, but it’s not elegant – and Swift has a better solution built right in.

// When used with an array of strings, the contains(where:) method wants to call a closure that accepts a string and returns true or false.
// The contains() method of String accepts a string as its parameter and returns true or false.
// Swift massively blurs the lines between functions, methods, closures, and more.
// So, what we can actually do is pass one function directly into the other, like this:
print(languages.contains(where: input.contains))

// Don’t feel bad if you need to read that single line of code several times – it’s not easy! Let’s break it down.

// contains(where:) will call its closure once for every element in the languages array until it finds one that returns true, at which point it stops.

// In that code we’re passing input.contains as the closure that contains(where:) should run. This means Swift will call input.contains("Python") and get back false, then it will call input.contains("Ruby") and get back false again, and finally call input.contains("Swift") and get back true – then stop there.

// Swift’s strings are plain text, which works fine in the vast majority of cases we work with text. But sometimes we want more – we want to be able to add formatting like bold or italics, select from different fonts, or add some color, and for those jobs we have a new class called NSAttributedString.

// Attributed strings are made up of two parts: a plain Swift string, plus a dictionary containing a series of attributes that describe how various segments of the string are formatted. In its most basic form you might want to create one set of attributes that affect the whole string, like this:

let string = "This is a test string\nOi"
let shadow = NSShadow()
shadow.shadowColor = UIColor.yellow
shadow.shadowOffset = CGSize(width: 2, height: 1)
let attributes: [NSAttributedString.Key: Any] = [
    .foregroundColor: UIColor.black,
    .backgroundColor: UIColor.black,
    .font: UIFont.boldSystemFont(ofSize: 36),
    NSAttributedString.Key.shadow: shadow]

let attributedString = NSAttributedString(string: string, attributes: attributes)


let attributedString2 = NSMutableAttributedString(string: string)
attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 5), range: NSRange(location: 0, length: 4))
attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 16), range: NSRange(location: 5, length: 2))
attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 24), range: NSRange(location: 8, length: 1))
attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 32), range: NSRange(location: 10, length: 4))
attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 40), range: NSRange(location: 15, length: 6))
// It’s common to use an explicit type annotation when making attributed strings, because inside the dictionary we can just write things like .foregroundColor for the key rather than NSAttributedString.Key.foregroundColor.

// The values of the attributes dictionary are of type Any, because NSAttributedString attributes can be all sorts of things: numbers, colors, fonts, paragraph styles, and more.

// If you look in the output pane of your playground, you should be able to click on the box next to where it says “This is a test string” to get a live preview of how our string looks – you should see large, white text with a red background.

attributedString2.addAttribute(.shadow, value: shadow, range: NSRange(location: 0, length: string.count))

attributedString2.addAttribute(.underlineStyle, value: NSUnderlineStyle.double.rawValue | NSUnderlineStyle.patternDash.rawValue, range: NSRange(location: 0, length: string.count))

let urls = URL(string: "http://facebook.com")!
attributedString2.addAttribute(.link, value: urls, range: NSRange(location: 0, length: string.count))


let paragraphStyle = NSMutableParagraphStyle()
paragraphStyle.firstLineHeadIndent = 10
paragraphStyle.headIndent = 5
paragraphStyle.tailIndent = -5

paragraphStyle.lineHeightMultiple = 0.85
paragraphStyle.alignment = .justified
paragraphStyle.minimumLineHeight = 0
paragraphStyle.maximumLineHeight = 0 // unlimited
paragraphStyle.lineSpacing = 5

paragraphStyle.paragraphSpacing = 15
paragraphStyle.paragraphSpacingBefore = 10

attributedString2.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: string.count))

let font: UIFont = UIFont(name: "BanglaSangamMN-Bold", size: 14)!
attributedString2.addAttribute(.font, value: font, range: NSRange(location: 0, length: string.count))

let lineHeight = max(0, min(18.9156, CGFloat.infinity)) + 5
print(lineHeight)

print(font.lineHeight - paragraphStyle.lineHeightMultiple * font.lineHeight)

// You might be wondering how useful all this knowledge is, but here’s the important part: UILabel, UITextField, UITextView, UIButton, UINavigationBar, and more all support attributed strings just as well as regular strings. So, for a label you would just use attributedText rather than text, and UIKit takes care of the rest.

extension String {
    
    func withPrefix(_ str: String) -> String {
        return str + self
    }
    
    func isNumeric() -> Bool {
        return Double(self) != nil
    }
    
    func lines() -> [String] {
        return self.components(separatedBy: "\n")
    }
}

print("pet".withPrefix("car"))

print("1g".isNumeric())

print("this\nis\na\ntest".lines())


