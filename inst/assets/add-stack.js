$(() => {
  const toast = bootstrap.Toast.getOrCreateInstance(
    document.getElementById("toast"),
  );

  $(document).on("masonry:added-row", (e) => {
    $(`#${e.detail}`).addClass("bg-secondary");
    setTimeout(() => {
      $(`#${e.detail}`).removeClass("bg-secondary");
    }, 1000);

    $(".remove-row").on("click", (event) => {
      // capture stacks contained in the row
      const stacks = [];
      $(event.target).closest(".masonry-row").find(".stack").find(".accordion")
        .each((_, el) => {
          stacks.push($(el).attr("id"));
        });

      // remove row from DOM
      const ns = $(event.target).closest(".dash-page").data("ns");
      Shiny.setInputValue(`${ns}-removeRow`, { stacks: stacks });
      $(event.target).closest(".masonry-row").remove();
    });
  });

  setTimeout(() => {
    const draggable = $(document).find(".nav-link");

    sortable = new Sortable(
      draggable[0],
      {
        draggable: ".add-stack",
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
    // for some reason sortable.js only works on direct children
    // so we look over wrappers
    $(document).find(".offcanvas-body").find(
      ".block-wrapper",
    ).each((_, el) => {
      new Sortable(
        el,
        {
          draggable: ".add-block",
          onEnd: (evt) => {
            const $stack = $(evt.explicitOriginalTarget).closest(".accordion");
            if (!$stack.length) {
              $("#toast-body").text("Blocks must be dropped within a stack");
              toast.show();
              return;
            }

            const stackId = $stack.attr("id")
              .split("-")[1];

            const blockId = $(evt.explicitOriginalTarget).closest(".block")
              .data(
                "value",
              );

            let blockIndex;
            $stack.find(
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
    });
  }, 300);
});
