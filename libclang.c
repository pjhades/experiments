#include <err.h>
#include <stdio.h>
#include <clang-c/Index.h>

enum CXChildVisitResult visitor(CXCursor cursor, CXCursor parent, CXClientData data)
{
    enum CXCursorKind kind = clang_getCursorKind(cursor);
    CXSourceLocation location = clang_getCursorLocation(cursor);

    if (clang_Location_isInSystemHeader(location))
        return CXChildVisit_Continue;

    CXString kind_spelling = clang_getCursorKindSpelling(kind);
    CXString spelling = clang_getCursorSpelling(cursor);
    CXString name = clang_getCursorDisplayName(cursor);
    printf("kind_spelling: %s, spelling: %s, display_name: %s\n",
           clang_getCString(kind_spelling),
           clang_getCString(spelling),
           clang_getCString(name));
    clang_disposeString(kind_spelling);
    clang_disposeString(spelling);
    clang_disposeString(name);

    return CXChildVisit_Recurse;
}

int main(int argc, char **argv)
{
    CXIndex index = clang_createIndex(0, 1);
    CXTranslationUnit unit = clang_parseTranslationUnit(index, "1.c",
            (const char **)argv + 1, argc - 1, NULL, 0, CXTranslationUnit_None);
    if (!unit)
        errx(1, "failed to parse");

    CXCursor cursor = clang_getTranslationUnitCursor(unit);
    clang_visitChildren(cursor, visitor, NULL);

    printf("%d\n", clang_getFile(unit, "1.c") == NULL);
    printf("%d\n", clang_getFile(unit, "0.h") == NULL);
    printf("%d\n", clang_getFile(unit, "x.emoji") == NULL);

    clang_disposeTranslationUnit(unit);
    clang_disposeIndex(index);

    return 0;
}
