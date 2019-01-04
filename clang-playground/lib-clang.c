#include <err.h>
#include <stdbool.h>
#include <stdio.h>
#include <clang-c/Index.h>

bool interested[] = {
    [CXCursor_StructDecl] = true,
    [CXCursor_UnionDecl] = true,
    [CXCursor_ClassDecl] = true,
    [CXCursor_EnumDecl] = true,
    [CXCursor_FieldDecl] = true,
    [CXCursor_EnumConstantDecl] = true,
    [CXCursor_FunctionDecl] = true,     
    [CXCursor_VarDecl] = true,
    [CXCursor_ParmDecl] = true,
    [CXCursor_TypedefDecl] = true,

    [CXCursor_TypeRef] = true,
    [CXCursor_MemberRef] = true,
    [CXCursor_LabelRef] = true,
    [CXCursor_VariableRef] = true,
    [CXCursor_DeclRefExpr] = true,
    [CXCursor_MemberRefExpr] = true,
    [CXCursor_CallExpr] = true,
};

enum CXChildVisitResult visitor(CXCursor cursor, CXCursor parent, CXClientData data)
{
    enum CXCursorKind kind = clang_getCursorKind(cursor);
    CXSourceLocation location = clang_getCursorLocation(cursor);

    if (clang_Location_isInSystemHeader(location))
        return CXChildVisit_Continue;

    CXFile file;
    unsigned line, col, off;
    if (interested[kind]) {
        clang_getSpellingLocation(location, &file, &line, &col, &off);
        CXString kind_spelling = clang_getCursorKindSpelling(kind);
        CXString spelling = clang_getCursorSpelling(cursor);
        CXString filename = clang_getFileName(file);

        printf("%-15s %-20s %s:%u:%u %c%c\n",
               clang_getCString(spelling),
               clang_getCString(kind_spelling),
               clang_getCString(filename),
               line,
               col,
               clang_isCursorDefinition(cursor) ? 'D' : '-',
               clang_isDeclaration(kind) ? 'd' : '-');

        clang_disposeString(kind_spelling);
        clang_disposeString(spelling);
        clang_disposeString(filename);
    }

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

    clang_disposeTranslationUnit(unit);
    clang_disposeIndex(index);

    return 0;
}
