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

    sortable = new Sortable(
      draggable[0],
      {
        onStart: () => {
          $(".masonry-row").addClass("bg-secondary");
        },
        onUnchoose: () => {
          $(".masonry-row").removeClass("bg-secondary");
        },
        onEnd: (evt) => {
          $(evt.explicitOriginalTarget).closest(".masonry-row").removeClass(
            "bg-secondary",
          );

          const rowID = $(evt.explicitOriginalTarget).closest(".masonry-row")
            .attr("id");
          const ns = $(evt.explicitOriginalTarget).closest(".dash-page").data(
            "ns",
          );
          Shiny.setInputValue(`${ns}-addStack`, rowID, { priority: "event" });
        },
      },
    );
  }, 300);

  setTimeout(() => {
    const draggable = $(document).find(".offcanvas-body");

    new Sortable(
      draggable[0],
      {
        draggable: ".add-block",
        onEnd: (evt) => {
          const stackId =
            $(evt.explicitOriginalTarget).closest(".accordion").attr("id")
              .split("-")[0];

          const blockId = $(evt.explicitOriginalTarget).closest(".block").data(
            "value",
          );

          let blockIndex;
          $(evt.explicitOriginalTarget).closest(".accordion").find(
            ".block",
          ).each((index, el) => {
            if ($(el).data("value") == blockId) {
              blockIndex = index + 1;
            }
          });

          const ns = $(evt.explicitOriginalTarget).closest(".dash-page").data(
            "ns",
          );

          Shiny.setInputValue(
            `${ns}-addBlock`,
            {
              stackId: stackId,
              blockId: blockId,
              blockIndex: blockIndex,
              type: $(evt.item).data("type"),
            },
            { priority: "event" },
          );
        },
      },
    );
  }, 300);
});
