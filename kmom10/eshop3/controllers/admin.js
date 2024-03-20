exports.index = (req, res, next) => {
    res.render("admin/index", {
        pageTitle: "Admin Home",
        path: "/admin",
    });
};


