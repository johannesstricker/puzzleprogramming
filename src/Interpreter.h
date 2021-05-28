#pragma once
#include <string>
#include <ostream>

class Token {
public:
  virtual std::string toString() const = 0;
};

std::ostream& operator<<(std::ostream& outstream, const Token& token);

class Number : public Token
{
public:
  Number(double value)
  : Value(value) {}

  virtual std::string toString() const override;

  double Value;
};

class OperatorPlus : public Token
{
public:
  Token* operator()(const Number*, const Number*);

  virtual std::string toString() const override;
};

Token* lex(const std::string& tokenString);

std::string interpret(const std::string& code);