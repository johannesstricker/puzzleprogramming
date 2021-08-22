#pragma once

#ifdef __cplusplus
extern "C"
{
#endif

// struct PuzzlePiece {
//   int typeIndex;
// };

// struct PuzzleSolution {
//   int piecesCount;
//   PuzzlePiece* pieces;
//   int value;
// };

int avoidCodeStripping(void);
char* detectAndDecodeArUco32BGRA(unsigned char* imageBytes, int imageWidth, int imageHeight, int bytesPerRow);
char* tokenToString(int tokenType, int value);
// PuzzleSolution solvePuzzle(unsigned char* imageBytes, int imageWidth, int imageHeight, int bytesPerRow);

#ifdef __cplusplus
}
#endif