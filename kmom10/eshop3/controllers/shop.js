exports.index = (req, res, next) => {
    res.render("shop/index", {
        pageTitle: "Shop Home",
        path: "/",
    });
};
