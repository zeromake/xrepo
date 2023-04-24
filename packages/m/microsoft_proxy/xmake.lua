package("microsoft_proxy")
    set_kind("library", {headeronly = true})
    set_homepage("https://github.com/microsoft/proxy")
    set_description("Proxy: Easy Polymorphism in C++")
    set_license("MIT")
    set_urls("https://github.com/microsoft/proxy/releases/download/$(version)/proxy-$(version).zip")

    add_versions("1.1.1", "a153c95b2ffe69f2f01c393d80da8364f7e3e3a35572691808133edb60f5834f")
    on_install(function (package)
        os.cp("*.h", package:installdir("include"))
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({
            test = [[
#include <string>
#include <sstream>

#include <proxy.h>

// Abstraction
struct Draw : pro::dispatch<void(std::ostream&)> {
  template <class T>
  void operator()(const T& self, std::ostream& out) { self.Draw(out); }
};
struct Area : pro::dispatch<double()> {
  template <class T>
  double operator()(const T& self) { return self.Area(); }
};
struct DrawableFacade : pro::facade<Draw, Area> {};

// Implementation
class Rectangle {
 public:
  void Draw(std::ostream& out) const
      { out << "{Rectangle: width = " << width_ << ", height = " << height_ << "}"; }
  void SetWidth(double width) { width_ = width; }
  void SetHeight(double height) { height_ = height; }
  double Area() const { return width_ * height_; }

 private:
  double width_;
  double height_;
};

// Client - Consumer
std::string PrintDrawableToString(pro::proxy<DrawableFacade> p) {
  std::stringstream result;
  result << "shape = ";
  p.invoke<Draw>(result);
  result << ", area = " << p.invoke<Area>();
  return std::move(result).str();
}

// Client - Producer
pro::proxy<DrawableFacade> CreateRectangleAsDrawable(int width, int height) {
  Rectangle rect;
  rect.SetWidth(width);
  rect.SetHeight(height);
  return pro::make_proxy<DrawableFacade>(rect);
}
]]
        }, {configs = {languages = "c++20"}}))
    end)
