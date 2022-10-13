import React from "react";
import Header from "./Header";

const Layout = ({children}) => {
  return (
    <div>
      <Header />
      {children}
      <div>Layout</div>
    </div>
  );
};

export default Layout;
