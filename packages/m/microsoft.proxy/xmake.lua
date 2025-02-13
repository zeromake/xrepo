package("microsoft.proxy")
    set_kind("library", {headeronly = true})
    set_homepage("https://github.com/microsoft/proxy")
    set_description("Proxy: Easy Polymorphism in C++")
    set_license("MIT")
    set_urls("https://github.com/microsoft/proxy/archive/refs/tags/$(version).tar.gz")

    --insert version
    add_versions("3.2.0", "a828432a43a1e05c65176e58b48a6d6270669862adb437a069693f346275b5f0")
    add_versions("3.1.0", "c86ed7767ed3e90250632f2b5269c83225b0ae986314c58596d421b245f26cd1")
    add_versions("3.0.0", "7e073e217e5572bc4c17ed5893273c80ea34c87e1406c853beeb9ca9bdda9733")
    on_install(function (package)
        os.cp("*.h", package:installdir("include/proxy"))
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({
            test = [[
#include <iostream>
#include <sstream>

#include "proxy.h"

PRO_DEF_MEM_DISPATCH(MemDraw, Draw);
PRO_DEF_MEM_DISPATCH(MemArea, Area);

struct Drawable : pro::facade_builder
    ::add_convention<MemDraw, void(std::ostream& output)>
    ::add_convention<MemArea, double() noexcept>
    ::support_copy<pro::constraint_level::nontrivial>
    ::build {};

class Rectangle {
 public:
  Rectangle(double width, double height) : width_(width), height_(height) {}
  Rectangle(const Rectangle&) = default;

  void Draw(std::ostream& out) const {
    out << "{Rectangle: width = " << width_ << ", height = " << height_ << "}";
  }
  double Area() const noexcept { return width_ * height_; }

 private:
  double width_;
  double height_;
};

std::string PrintDrawableToString(pro::proxy<Drawable> p) {
  std::stringstream result;
  result << "entity = ";
  p->Draw(result);
  result << ", area = " << p->Area();
  return std::move(result).str();
}

int main() {
  pro::proxy<Drawable> p = pro::make_proxy<Drawable, Rectangle>(3, 5);
  std::string str = PrintDrawableToString(p);
  std::cout << str << "\n";  // Prints: "entity = {Rectangle: width = 3, height = 5}, area = 15"
}
]]
        }, {configs = {languages = "c++20"}}))
    end)
