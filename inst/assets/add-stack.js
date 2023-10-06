$(() => {
  $(document).on("masonry:added-row", (e) => {
    $(`#${e.detail}`).addClass("bg-secondary");
    setTimeout(() => {
      $(`#${e.detail}`).removeClass("bg-secondary");
    }, 1000);

    $(".remove-row").on("click", (event) => {
      const n =
        $(event.target).closest(".masonry-grid").find(".masonry-row").length;
      if (n == 1) {
        return;
      }
      $(event.target).closest(".masonry-row").remove();
    });
  });

  setTimeout(() => {
    const draggable = $(document).find(".add-stack");

    const sortable = new Sortable(
      draggable[0],
      {
        onStart: (evt) => {
          $(".masonry-row").addClass("bg-secondary");
        },
        onUnchoose: (evt) => {
          $(".masonry-row").removeClass("bg-secondary");
        },
        onEnd: (evt) => {
          $(evt.explicitOriginalTarget).closest(".masonry-row").removeClass(
            "bg-secondary",
          );

          let rowID = $(evt.explicitOriginalTarget).closest(".masonry-row")
            .attr("id");
          const ns = $(evt.explicitOriginalTarget).closest(".dash-page").data(
            "ns",
          );
          Shiny.setInputValue(`${ns}-addStack`, rowID, { priority: "event" });
        },
      },
    );
  }, 300);
});
