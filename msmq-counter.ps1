# Author: Hung Vo - it.minhhung@gmail.com
# SAMPLE OF RESULT
# msmq_queue_message_count{queue_name="private$\\\\slackbotmessagestore",machine_name="jinpc"} 0
# msmq_queue_bytes_in_queue{queue_name="private$\\\\slackbotmessagestore",machine_name="jinpc"} 0
# msmq_queue_journal_message_count{queue_name="private$\\\\slackbotmessagestore",machine_name="jinpc"} 0
# msmq_queue_transactional{queue_name="private$\\\\slackbotmessagestore",machine_name="jinpc"} 1

param (
    [int]$Port = 9184
)

try {
    # Define the HTTP listener
    $listener = [System.Net.HttpListener]::new()
    $listener.Prefixes.Add("http://*:$Port/metrics/")
    $listener.Start()
    Write-Output "Listening on http://*:$Port/metrics/"

    while ($true) {
        try {
            # Wait for an incoming request
            $context = $listener.GetContext()
            $response = $context.Response

            # Collect MSMQ data
            $msmqData = Get-MsmqQueue | Select QueueName, MessageCount, BytesInQueue, MachineName, JournalMessageCount, Transactional

            # Format the data for Prometheus
            $metrics = @()
            foreach ($queue in $msmqData) {
                $queueName = $queue.QueueName -replace "\\", "\\\\"
                $machineName = $queue.MachineName -replace "\\", "\\\\"

                $metrics += "msmq_queue_message_count{queue_name=`"$queueName`",machine_name=`"$machineName`"} $($queue.MessageCount)"
                $metrics += "msmq_queue_bytes_in_queue{queue_name=`"$queueName`",machine_name=`"$machineName`"} $($queue.BytesInQueue)"
                $metrics += "msmq_queue_journal_message_count{queue_name=`"$queueName`",machine_name=`"$machineName`"} $($queue.JournalMessageCount)"
                $metrics += "msmq_queue_transactional{queue_name=`"$queueName`",machine_name=`"$machineName`"} $([int]$queue.Transactional)"
            }
            $metricsOutput = $metrics -join "`n"

            # Write the metrics to the response
            $buffer = [System.Text.Encoding]::UTF8.GetBytes($metricsOutput)
            $response.ContentLength64 = $buffer.Length
            $response.OutputStream.Write($buffer, 0, $buffer.Length)
            $response.OutputStream.Close()
        } catch {
            Write-Error "Error processing request: $_"
        }
    }
} catch {
    Write-Error "Failed to start HTTP listener: $_"
} finally {
    if ($listener) {
        $listener.Stop()
        $listener.Close()
    }
}
