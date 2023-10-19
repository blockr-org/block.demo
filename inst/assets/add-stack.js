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
      $(event.target).closest(".masonry-row").find(".stack")
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
            const $stack = $(evt.explicitOriginalTarget).closest(".stack");

            // it's not dropped in a stack
            if (!$stack.length) {
              $("#toast-body").text("Blocks must be dropped within a stack");
              toast.show();
              return;
            }

            const blockType = $(evt.item).data("type");

            // we get all block types in the stack
            // to check whether the block to add is compatible
            const blockTypes = [];
            $(evt.explicitOriginalTarget).closest(".stack").find(
              "[data-block-type]",
            ).each((_, el) => {
              const vals = $(el).data("block-type").split(",");
              blockTypes.push(...vals);
            });

            // get stackId
            const stackId = $stack.attr("id")
              .split("-")[1];

            // get block id
            const blockId = $(evt.explicitOriginalTarget).closest(".block")
              .data(
                "value",
              );

            // get index where the user wants to insert the block
            let blockIndex;
            $stack.find(
              ".block",
            ).each((index, el) => {
              if ($(el).data("value") == blockId) {
                blockIndex = index + 1;
              }
            });

            if (!blockIndex) {
              $("#toast-body").text("Could not find block index");
              toast.show();
              return;
            }

            // check whether stack already has a data block
            if (
              blockTypes.includes("dataset_block") &&
              blockType == "dataset_block"
            ) {
              $("#toast-body").text("This stack already includes a data block");
              toast.show();
              return;
            }

            // check whether stack already has a plot block
            if (
              blockTypes.includes("plot_block") && blockType == "plot_block"
            ) {
              $("#toast-body").text("This stack already includes a plot block");
              toast.show();
              return;
            }

            // get the type of block the user wants to insert a
            const insertType = $(`.block:eq(${blockIndex - 1})`).data(
              "block-type",
            ).split(",");

            if (insertType == "plot") {
              $("#toast-body").text("Cannot insert a block after a plot block");
              toast.show();
              return;
            }

            const ns = $(evt.explicitOriginalTarget).closest(".dash-page").data(
              "ns",
            );

            Shiny.setInputValue(
              `${ns}-addBlock`,
              {
                stackId: stackId,
                blockId: blockId,
                blockIndex: blockIndex,
                type: blockType,
              },
              { priority: "event" },
            );
          },
        },
      );
    });
  }, 300);
});
