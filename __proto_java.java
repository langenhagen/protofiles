// author: langenhagen
// version: 17-12-08


// -------------------------------------------------------------------------------------------------
// read a file into string ("a compact, robust Java 7 idiom")
// taken from https://stackoverflow.com/questions/326390/how-do-i-create-a-java-string-from-the-contents-of-a-file

/**
 * Reatds a file from a given path and with a given charset into a string which it returns.
 * @param path The path to a file.
 * @param encoding A charset encodding.
 * @return A string containing the contents of the file.
 * @throws IOException
 */
private static String readFile(String path, Charset encoding) throws IOException {
    byte[] encoded = Files.readAllBytes(Paths.get(path));
    return new String(encoded, encoding);
}