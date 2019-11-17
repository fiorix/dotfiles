package main

import (
	"fmt"
	"os"
	"time"

	"github.com/spf13/cobra"
)

func main() {
	MainCommand.AddCommand(DurationCommand())

	if err := MainCommand.Execute(); err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}
}

// MainCommand ...
var MainCommand = &cobra.Command{
	Use: "hmnz",
}

// DurationCommand ...
func DurationCommand() *cobra.Command {
	return &cobra.Command{
		Use:     "duration [<since> | <start> <end>]",
		Short:   "Prints humanized duration from timestamps",
		Example: "hmnz duration $(date +%s.%N)\nhmnz duration $(date +%s.%N) $(sleep .2 && date +%s.%N)",
		Run: func(cmd *cobra.Command, args []string) {
			if len(args) < 1 {
				cmd.Usage()
				os.Exit(1)
			}

			const precision = 1 * time.Millisecond
			labels := []string{"start", "end"}
			values := make([]time.Time, 2)

			for i, arg := range args {
				var sec, nsec int64

				_, err := fmt.Sscanf(arg, "%d.%d", &sec, &nsec)
				if err != nil {
					fmt.Fprintf(os.Stderr, "cannot parse %s time: %v\n", labels[i], err)
					fmt.Fprintf(os.Stderr, "expected time layout is 'sec.nsec', check out the example below\n\n")
					cmd.Usage()
					os.Exit(1)
				}

				values[i] = time.Unix(sec, nsec).Truncate(precision)
			}

			if len(args) == 1 {
				values[1] = time.Now().Truncate(precision)
			}

			elapsed := values[1].Sub(values[0])
			fmt.Fprintln(os.Stdout, elapsed)
		},
	}
}
